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