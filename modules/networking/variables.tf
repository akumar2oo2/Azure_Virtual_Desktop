# Inputs for the networking module.

variable "resource_group_name" {
  description = "Name of the resource group hosting the networking resources"
  type        = string
}

variable "location" {
  description = "Azure region for the networking resources"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space assigned to the virtual network"
  type        = list(string)
}

variable "subnet_definitions" {
  description = "Subnet configuration definitions"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "network_security_groups" {
  description = "Network Security Group definitions"
  type = map(object({
    name = string
  }))
}

variable "tags" {
  description = "Tags applied to networking resources"
  type        = map(string)
  default     = {}
}