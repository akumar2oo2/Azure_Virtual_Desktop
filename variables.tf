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