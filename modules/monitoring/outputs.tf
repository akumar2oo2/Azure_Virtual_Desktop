# Outputs exposed for consumption by other modules and the root module.

output "law_id" {
  description = "Log Analytics Workspace ID"
  value = (
    length(azurerm_log_analytics_workspace.law) > 0
    ? azurerm_log_analytics_workspace.law[0].id
    : null
  )
}

output "law_name" {
  description = "Log Analytics Workspace name"
  value = (
    length(azurerm_log_analytics_workspace.law) > 0
    ? azurerm_log_analytics_workspace.law[0].name
    : null
  )
}

output "dcr_ids" {
  description = "Map of Data Collection Rule IDs"

  value = {
    for key, dcr in azurerm_monitor_data_collection_rule.dcrs :
    key => dcr.id
  }
}

output "dcr_names" {
  description = "Map of Data Collection Rule names"

  value = {
    for key, dcr in azurerm_monitor_data_collection_rule.dcrs :
    key => dcr.name
  }
}

output "workbook_ids" {
  description = "Map of Workbook IDs"

  value = {
    for key, workbook in azurerm_application_insights_workbook.workbooks :
    key => workbook.id
  }
}

output "workbook_names" {
  description = "Map of Workbook display names"

  value = {
    for key, workbook in azurerm_application_insights_workbook.workbooks :
    key => workbook.display_name
  }
}

output "action_group_ids" {
  description = "Map of Action Group IDs"

  value = {
    for key, action_group in azurerm_monitor_action_group.action_groups :
    key => action_group.id
  }
}

output "action_group_names" {
  description = "Map of Action Group names"

  value = {
    for key, action_group in azurerm_monitor_action_group.action_groups :
    key => action_group.name
  }
}