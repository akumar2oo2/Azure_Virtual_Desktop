# Common Variables
# These variables establish the standard deployment
# configuration used across all environments.

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition = contains(
      ["dev", "test", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, test, or prod."
  }
}

variable "project_prefix" {
  description = "Platform naming prefix"
  type        = string
  default     = "AK"
}

variable "project_name" {
  description = "Platform name"
  type        = string
  default     = "AVD"
}

variable "location" {
  description = "Azure deployment region"
  type        = string
  default     = "centralindia"
}

# -----------------------------------------------------------------------------
# Phase 3 - Image Gallery variables
# -----------------------------------------------------------------------------

variable "image_publisher" {
  description = "Publisher identifier stored in the image definition"
  type        = string
}

variable "image_offer" {
  description = "Offer identifier stored in the image definition"
  type        = string
}

variable "image_sku" {
  description = "SKU identifier stored in the image definition"
  type        = string
}

variable "tags" {
  description = "Common tags applied to every resource"
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Phase 5 - Core Infrastructure variables
# -----------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space assigned to the Virtual Network"
  type        = list(string)
}

variable "subnet_definitions" {
  description = "Subnet configuration definitions"
  type = map(object({
    address_prefixes = list(string)
  }))
}

# -----------------------------------------------------------------------------
# Phase 6 - Identity variables
# -----------------------------------------------------------------------------

variable "deploy_identity" {
  description = "Controls deployment of identity resources"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Phase 7 - Azure Virtual Desktop variables
# -----------------------------------------------------------------------------

variable "deploy_avd" {
  description = "Controls deployment of Azure Virtual Desktop resources"
  type        = bool
  default     = false
}

variable "host_pools" {
  description = "Azure Virtual Desktop Host Pool and Session Host configurations"

  type = map(object({
    host_pool_name                   = string
    host_pool_type                   = string
    application_group_type           = string
    load_balancer_type               = optional(string)
    personal_desktop_assignment_type = optional(string)

    session_hosts = object({
      enabled = bool

      count   = number
      vm_size = string

      join_type = string

      image = object({
        definition = string
        version    = string
      })

      network = object({
        subnet_key = string
      })

      os_disk = object({
        storage_account_type = string
        disk_size_gb         = number
        caching              = string
      })

      monitoring = object({
        ama_enabled = bool
        dcr_keys    = list(string)
      })
    })
  }))

  default = {}

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      contains(["Pooled", "Personal"], hp.host_pool_type)
    ])

    error_message = "host_pool_type must be Pooled or Personal."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      contains(["Desktop", "RemoteApp"], hp.application_group_type)
    ])

    error_message = "application_group_type must be Desktop or RemoteApp."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      hp.session_hosts.count >= 0
    ])

    error_message = "Session Host count must be zero or greater."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      !hp.session_hosts.enabled || trimspace(hp.session_hosts.vm_size) != ""
    ])

    error_message = "vm_size must not be empty when Session Host deployment is enabled."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      contains(["EntraID"], hp.session_hosts.join_type)
    ])

    error_message = "join_type must be EntraID."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      !hp.session_hosts.enabled || trimspace(hp.session_hosts.image.definition) != ""
    ])

    error_message = "Image definition must not be empty when Session Host deployment is enabled."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      !hp.session_hosts.enabled || trimspace(hp.session_hosts.image.version) != ""
    ])

    error_message = "Image version must not be empty when Session Host deployment is enabled."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      !hp.session_hosts.enabled || trimspace(hp.session_hosts.network.subnet_key) != ""
    ])

    error_message = "Session Host subnet_key must not be empty when Session Host deployment is enabled."
  }

  validation {
    condition = alltrue([
      for hp in values(var.host_pools) :
      hp.session_hosts.os_disk.disk_size_gb > 0
    ])

    error_message = "Session Host OS disk size must be greater than zero."
  }
}

# -----------------------------------------------------------------------------
# Phase 8 - Monitoring variables
# -----------------------------------------------------------------------------

variable "deploy_monitoring" {
  description = "Controls deployment of monitoring resources"
  type        = bool
  default     = false
}

variable "monitoring" {
  description = "Object-driven monitoring platform configuration"

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
      description                = string
      windows_event_logs         = list(string)
      performance_counters       = list(string)
      sampling_frequency_seconds = number
    }))

    workbooks = map(object({
      enabled      = bool
      display_name = string
      description  = string
    }))

    action_groups = map(object({
      enabled    = bool
      short_name = string

      email_receivers = optional(list(object({
        name          = string
        email_address = string
      })), [])
    }))

    alerts = map(object({
      enabled              = bool
      severity             = number
      threshold            = optional(number)
      evaluation_frequency = string
      window_size          = string
      action_group         = string

      query              = string
      operator           = string
      aggregation_method = string

      minimum_failing_periods_to_trigger = number
      number_of_evaluation_periods = number
      auto_mitigation_enabled = bool
      skip_query_validation = bool
    }))
  })
}

# -----------------------------------------------------------------------------
# Phase 9 - Session Host variables
# -----------------------------------------------------------------------------

variable "session_host_admin_username" {
  description = "Local administrator username for Session Host virtual machines"
  type        = string
}

variable "session_host_admin_password" {
  description = "Local administrator password for Session Host virtual machines"
  type        = string
  sensitive   = true
}

variable "avd_registration_artifact_url" {
  description = "URL of the Microsoft Azure Virtual Desktop Session Host registration artifact"
  type        = string
}