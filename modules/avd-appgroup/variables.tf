# Inputs for the avd-appgroup module.

variable "resource_group_name" {
  description = "Name of the resource group hosting the Azure Virtual Desktop application group"
  type        = string
}

variable "location" {
  description = "Azure region for the Azure Virtual Desktop application group"
  type        = string
}

variable "host_pool_id" {
  description = "Azure Virtual Desktop host pool ID"
  type        = string
}

variable "workspace_id" {
  description = "Azure Virtual Desktop workspace ID"
  type        = string
}

variable "application_group_name" {
  description = "Name of the Azure Virtual Desktop application group"
  type        = string
}

variable "application_group_type" {
  description = "Azure Virtual Desktop application group type"
  type        = string
}

variable "application_group_friendly_name" {
  description = "Friendly name of the Azure Virtual Desktop application group"
  type        = string
}

variable "tags" {
  description = "Tags applied to the Azure Virtual Desktop application group"
  type        = map(string)
  default     = {}
}