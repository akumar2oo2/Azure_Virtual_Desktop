# Outputs exposed for consumption by other modules and the root module.

output "workspace_id" {
  description = "Azure Virtual Desktop workspace ID"
  value       = azurerm_virtual_desktop_workspace.workspace.id
}

output "workspace_name" {
  description = "Azure Virtual Desktop workspace name"
  value       = azurerm_virtual_desktop_workspace.workspace.name
}