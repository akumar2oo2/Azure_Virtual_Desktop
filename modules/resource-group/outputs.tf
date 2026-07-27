# Outputs exposed for consumption by other modules and the root module.

output "resource_group_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.rg.location
}