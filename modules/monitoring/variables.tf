# Inputs for the monitoring module.

variable "resource_group_name" {
  description = "Name of the resource group hosting the monitoring resources"
  type        = string
}

variable "location" {
  description = "Azure region for the monitoring resources"
  type        = string
}

variable "law_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "monitoring" {
  description = "Object-driven configuration for the monitoring platform"

  type = object({
    enabled = bool

    law = object({
      enabled        = bool
      retention_days = number
      daily_quota_gb = number
      sku            = string
    })

    dcrs = map(object({
      enabled                    = bool
      name                       = string
      description                = string
      windows_event_logs         = list(string)
      performance_counters       = list(string)
      sampling_frequency_seconds = number
    }))

    workbooks = map(object({
      enabled      = bool
      workbook_id  = string
      display_name = string
      description  = string
      data_json    = string
    }))

    action_groups = map(object({
      enabled    = bool
      name       = string
      short_name = string

      email_receivers = optional(list(object({
        name                    = string
        email_address           = string
        use_common_alert_schema = optional(bool, true)
      })), [])
    }))

    alerts = map(object({
      enabled              = bool
      name                 = string
      display_name         = string
      description          = string
      severity             = number
      evaluation_frequency = string
      window_size          = string
      action_group         = string

      query              = string
      aggregation_method = string
      operator           = string
      threshold          = number

      minimum_failing_periods_to_trigger = number
      number_of_evaluation_periods       = number
      auto_mitigation_enabled            = bool
      skip_query_validation              = bool
    }))
  })
}

variable "tags" {
  description = "Tags applied to monitoring resources"
  type        = map(string)
  default     = {}
}