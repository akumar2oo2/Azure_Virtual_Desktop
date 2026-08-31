# Inputs for the avd-workspace module.

variable "resource_group_name" {
  description = "Name of the resource group hosting the Azure Virtual Desktop workspace"
  type        = string
}

variable "location" {
  description = "Azure region for the Azure Virtual Desktop workspace"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Azure Virtual Desktop workspace"
  type        = string
}

variable "workspace_friendly_name" {
  description = "Friendly name of the Azure Virtual Desktop workspace"
  type        = string
}

variable "tags" {
  description = "Tags applied to the Azure Virtual Desktop workspace"
  type        = map(string)
  default     = {}
}