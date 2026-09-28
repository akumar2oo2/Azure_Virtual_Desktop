# Inputs for the Session Hosts module.

variable "resource_group_name" {
  description = "Name of the resource group where Session Host resources are deployed"
  type        = string
}

variable "location" {
  description = "Azure region for Session Host resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "host_pool_key" {
  description = "Map key identifying the Azure Virtual Desktop host pool"
  type        = string
}

variable "host_pool_id" {
  description = "Resource ID of the Azure Virtual Desktop host pool"
  type        = string
}

variable "host_pool_name" {
  description = "Name of the Azure Virtual Desktop host pool"
  type        = string
}

variable "session_host_names" {
  description = "Map of Session Host VM names keyed by Session Host instance"
  type        = map(string)
}

variable "computer_names" {
  description = "Map of Windows computer names keyed by Session Host instance"
  type        = map(string)
}

variable "network_interface_names" {
  description = "Map of Session Host network interface names keyed by Session Host instance"
  type        = map(string)
}

variable "session_hosts" {
  description = "Session Host deployment configuration for the host pool"

  type = object({
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
}

variable "subnet_id" {
  description = "Resource ID of the subnet used by Session Hosts"
  type        = string
}

variable "image_id" {
  description = "Resource ID of the Azure Compute Gallery image version used by Session Hosts"
  type        = string
}

variable "dcr_ids" {
  description = "Map of Data Collection Rule IDs selected for the Session Hosts"
  type        = map(string)
  default     = {}
}

variable "registration_token" {
  description = "Temporary Azure Virtual Desktop host pool registration token"
  type        = string
  sensitive   = true
}

variable "avd_registration_artifact_url" {
  description = "URL of the Microsoft Azure Virtual Desktop Session Host registration artifact"
  type        = string
}

variable "admin_username" {
  description = "Local administrator username for the Session Host virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Local administrator password for the Session Host virtual machines"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to Session Host resources"
  type        = map(string)
  default     = {}
}