# Production Environment Configuration
# Used when the GitHub Actions workflow is executed with:
# environment = prod
#
# This file contains environment-specific values that Terraform
# uses during planning and deployment.

environment = "test"

# Standard resource naming prefix.
project_prefix = "AK"

# Azure Virtual Desktop project name.
project_name = "AVD"

# Primary Azure region for production resources.
location = "centralindia"

# Image definition metadata (identifier only - not a marketplace pull).
image_publisher = "MicrosoftWindowsDesktop"
image_offer     = "Windows-11"
image_sku       = "win11-23h2-avd"

# Common resource tags.
tags = {
  AKProject = "AVD"
  Workload  = "ImageGallery"
}

# -----------------------------------------------------------------------------
# Phase 5 - Core Infrastructure configuration
# -----------------------------------------------------------------------------

vnet_address_space = [
  "10.20.0.0/16"
]

subnet_definitions = {
  sessionhosts = {
    address_prefixes = ["10.20.1.0/24"]
  }

  build = {
    address_prefixes = ["10.20.2.0/24"]
  }

  management = {
    address_prefixes = ["10.20.3.0/24"]
  }
}

# -----------------------------------------------------------------------------
# Phase 6 - Identity configuration
# -----------------------------------------------------------------------------

deploy_identity = false

# -----------------------------------------------------------------------------
# Phase 7 - Azure Virtual Desktop configuration
# -----------------------------------------------------------------------------

deploy_avd = true

host_pools = {
  general = {
    host_pool_name                   = "GENERAL"
    host_pool_type                   = "Pooled"
    application_group_type           = "Desktop"
    load_balancer_type               = "BreadthFirst"
    personal_desktop_assignment_type = null
  }

  developers = {
    host_pool_name                   = "DEVELOPERS"
    host_pool_type                   = "Personal"
    application_group_type           = "Desktop"
    load_balancer_type               = null
    personal_desktop_assignment_type = "Automatic"
  }

  finance = {
    host_pool_name                   = "FINANCE"
    host_pool_type                   = "Pooled"
    application_group_type           = "RemoteApp"
    load_balancer_type               = "DepthFirst"
    personal_desktop_assignment_type = null
  }
}

# -----------------------------------------------------------------------------
# Phase 8 - Monitoring configuration
# -----------------------------------------------------------------------------

deploy_monitoring = true

monitoring = {
  enabled = true

  law = {
    enabled        = true
    retention_days = 30
    daily_quota_gb = -1
    sku            = "PerGB2018"
  }

  dcrs = {
    sessionhosts = {
      enabled     = true
      description = "AVD Session Host Monitoring"

      windows_event_logs = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]

      performance_counters = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\% Committed Bytes In Use"
      ]

      sampling_frequency_seconds = 60
    }

    fslogix = {
      enabled     = true
      description = "FSLogix Monitoring"

      windows_event_logs = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]

      performance_counters = [
        "\\LogicalDisk(_Total)\\% Free Space"
      ]

      sampling_frequency_seconds = 60
    }

    platform = {
      enabled     = true
      description = "Platform Monitoring"

      windows_event_logs = [
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]

      performance_counters = [
        "\\System\\Processes"
      ]

      sampling_frequency_seconds = 60
    }
  }

  workbooks = {
    avd = {
      enabled      = true
      display_name = "Azure Virtual Desktop Overview"
      description  = "Azure Virtual Desktop Monitoring Workbook"
    }

    sessionhosts = {
      enabled      = true
      display_name = "Session Host Overview"
      description  = "Session Host Monitoring Workbook"
    }

    fslogix = {
      enabled      = true
      display_name = "FSLogix Overview"
      description  = "FSLogix Monitoring Workbook"
    }
  }

  action_groups = {
    operations = {
      enabled    = true
      short_name = "ops"

      email_receivers = []
    }

    platform = {
      enabled    = true
      short_name = "platform"

      email_receivers = []
    }
  }

  alerts = {
    cpu = {
      enabled              = true
      severity             = 2
      threshold            = 80
      evaluation_frequency = "PT5M"
      window_size          = "PT15M"
      action_group         = "operations"

      query              = "Heartbeat | count"
      operator           = "GreaterThan"
      aggregation_method = "Count"

      minimum_failing_periods_to_trigger = 1
      number_of_evaluation_periods       = 1

      auto_mitigation_enabled = true
      skip_query_validation   = true
    }

    memory = {
      enabled              = true
      severity             = 2
      threshold            = 85
      evaluation_frequency = "PT5M"
      window_size          = "PT15M"
      action_group         = "operations"

      query              = "Heartbeat | count"
      operator           = "GreaterThan"
      aggregation_method = "Count"

      minimum_failing_periods_to_trigger = 1
      number_of_evaluation_periods       = 1

      auto_mitigation_enabled = true
      skip_query_validation   = true
    }

    heartbeat = {
      enabled              = true
      severity             = 1
      threshold            = 1
      evaluation_frequency = "PT5M"
      window_size          = "PT15M"
      action_group         = "platform"

      query              = "Heartbeat | count"
      operator           = "GreaterThan"
      aggregation_method = "Count"

      minimum_failing_periods_to_trigger = 1
      number_of_evaluation_periods       = 1

      auto_mitigation_enabled = true
      skip_query_validation   = true
    }
  }
}