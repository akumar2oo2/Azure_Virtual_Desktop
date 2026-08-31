# Inputs for the avd-hostpool module.

variable "resource_group_name" {
  description = "Name of the resource group hosting the Azure Virtual Desktop host pool"
  type        = string
}

variable "location" {
  description = "Azure region for the Azure Virtual Desktop host pool"
  type        = string
}

variable "host_pool_name" {
  description = "Name of the Azure Virtual Desktop host pool"
  type        = string
}

variable "host_pool_type" {
  description = "Azure Virtual Desktop host pool type"
  type        = string
}

variable "load_balancer_type" {
  description = "Load balancing method for pooled host pools"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the Azure Virtual Desktop host pool"
  type        = map(string)
  default     = {}
}