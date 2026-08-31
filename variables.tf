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
  description = "Azure Virtual Desktop host pool configuration"

  type = map(object({
    host_pool_name         = string
    host_pool_type         = string
    application_group_type = string
    load_balancer_type     = optional(string)
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
}