# Outputs exposed for consumption by other modules and the root module.

output "application_group_id" {
  description = "Azure Virtual Desktop application group ID"
  value       = azurerm_virtual_desktop_application_group.appgroup.id
}

output "application_group_name" {
  description = "Azure Virtual Desktop application group name"
  value       = azurerm_virtual_desktop_application_group.appgroup.name
}