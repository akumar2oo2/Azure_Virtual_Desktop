# Outputs exposed for consumption by other modules and the root module.

output "admin_group_id" {
  description = "Administrators group ID"
  value       = azuread_group.admins.object_id
}

output "admin_group_name" {
  description = "Administrators group name"
  value       = azuread_group.admins.display_name
}

output "user_group_id" {
  description = "Users group ID"
  value       = azuread_group.users.object_id
}

output "user_group_name" {
  description = "Users group name"
  value       = azuread_group.users.display_name
}

output "helpdesk_group_id" {
  description = "Helpdesk group ID"
  value       = azuread_group.helpdesk.object_id
}

output "helpdesk_group_name" {
  description = "Helpdesk group name"
  value       = azuread_group.helpdesk.display_name
}