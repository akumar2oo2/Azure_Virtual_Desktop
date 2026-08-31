# Inputs for the identity module.

variable "admin_group_name" {
  description = "Microsoft Entra ID administrators group name"
  type        = string
}

variable "user_group_name" {
  description = "Microsoft Entra ID users group name"
  type        = string
}

variable "helpdesk_group_name" {
  description = "Microsoft Entra ID helpdesk group name"
  type        = string
}