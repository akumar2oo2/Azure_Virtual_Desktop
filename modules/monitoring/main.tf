# =============================================================================
# LOCAL VALUES
# =============================================================================

# Filter enabled monitoring objects before resource creation.
locals {
  enabled_dcrs = {
    for key, dcr in var.monitoring.dcrs :
    key => dcr
    if var.monitoring.enabled && var.monitoring.law.enabled && dcr.enabled
  }

  enabled_workbooks = {
    for key, workbook in var.monitoring.workbooks :
    key => workbook
    if var.monitoring.enabled && var.monitoring.law.enabled && workbook.enabled
  }

  enabled_action_groups = {
    for key, action_group in var.monitoring.action_groups :
    key => action_group
    if var.monitoring.enabled && action_group.enabled
  }

  enabled_alerts = {
    for key, alert in var.monitoring.alerts :
    key => alert
    if var.monitoring.enabled && var.monitoring.law.enabled && alert.enabled
  }
}

# =============================================================================
# LOG ANALYTICS WORKSPACE
# =============================================================================

# Create the centralized Log Analytics Workspace.
resource "azurerm_log_analytics_workspace" "law" {
  count = var.monitoring.enabled && var.monitoring.law.enabled ? 1 : 0

  name                = var.law_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.monitoring.law.sku
  retention_in_days = var.monitoring.law.retention_days
  daily_quota_gb    = var.monitoring.law.daily_quota_gb

  tags = var.tags
}

# =============================================================================
# DATA COLLECTION RULES
# =============================================================================

# Create the enabled Azure Monitor Data Collection Rules.
resource "azurerm_monitor_data_collection_rule" "dcrs" {
  for_each = local.enabled_dcrs

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = each.value.description

  destinations {
    log_analytics {
      name                  = "law-${each.key}"
      workspace_resource_id = azurerm_log_analytics_workspace.law[0].id
    }
  }

  data_sources {
    dynamic "windows_event_log" {
      for_each = length(each.value.windows_event_logs) > 0 ? [1] : []

      content {
        name           = "windows-events-${each.key}"
        streams        = ["Microsoft-WindowsEvent"]
        x_path_queries = each.value.windows_event_logs
      }
    }

    dynamic "performance_counter" {
      for_each = length(each.value.performance_counters) > 0 ? [1] : []

      content {
        name                          = "performance-counters-${each.key}"
        streams                       = ["Microsoft-Perf"]
        counter_specifiers            = each.value.performance_counters
        sampling_frequency_in_seconds = each.value.sampling_frequency_seconds
      }
    }
  }

  dynamic "data_flow" {
    for_each = length(each.value.windows_event_logs) > 0 ? [1] : []

    content {
      streams      = ["Microsoft-WindowsEvent"]
      destinations = ["law-${each.key}"]
    }
  }

  dynamic "data_flow" {
    for_each = length(each.value.performance_counters) > 0 ? [1] : []

    content {
      streams      = ["Microsoft-Perf"]
      destinations = ["law-${each.key}"]
    }
  }

  tags = var.tags
}

# =============================================================================
# ACTION GROUPS
# =============================================================================

# Create the enabled Azure Monitor Action Groups.
resource "azurerm_monitor_action_group" "action_groups" {
  for_each = local.enabled_action_groups

  name                = each.value.name
  resource_group_name = var.resource_group_name
  short_name          = each.value.short_name
  enabled             = true

  dynamic "email_receiver" {
    for_each = each.value.email_receivers

    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = email_receiver.value.use_common_alert_schema
    }
  }

  tags = var.tags
}

# =============================================================================
# WORKBOOKS
# =============================================================================

# Create the enabled Azure Monitor Workbooks.
resource "azurerm_application_insights_workbook" "workbooks" {
  for_each = local.enabled_workbooks

  name                = each.value.workbook_id
  resource_group_name = var.resource_group_name
  location            = var.location

  display_name = each.value.display_name
  description  = each.value.description
  data_json    = each.value.data_json

  source_id = azurerm_log_analytics_workspace.law[0].id
  category  = "workbook"

  tags = var.tags
}

# =============================================================================
# ALERT RULES
# =============================================================================

# Create the enabled Log Analytics scheduled-query alert rules.
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts" {
  for_each = local.enabled_alerts

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  display_name         = each.value.display_name
  description          = each.value.description
  enabled              = true
  severity             = each.value.severity
  evaluation_frequency = each.value.evaluation_frequency
  window_duration      = each.value.window_size

  scopes = [
    azurerm_log_analytics_workspace.law[0].id
  ]

  criteria {
    query                   = each.value.query
    time_aggregation_method = each.value.aggregation_method
    operator                = each.value.operator
    threshold               = each.value.threshold

    failing_periods {
      minimum_failing_periods_to_trigger_alert = each.value.minimum_failing_periods_to_trigger
      number_of_evaluation_periods             = each.value.number_of_evaluation_periods
    }
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.action_groups[each.value.action_group].id
    ]
  }

  auto_mitigation_enabled = each.value.auto_mitigation_enabled
  skip_query_validation   = each.value.skip_query_validation

  tags = var.tags
}