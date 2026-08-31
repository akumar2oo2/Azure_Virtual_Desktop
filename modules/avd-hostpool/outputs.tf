# Outputs exposed for consumption by other modules and the root module.

output "host_pool_id" {
  description = "Azure Virtual Desktop host pool ID"
  value       = azurerm_virtual_desktop_host_pool.hostpool.id
}

output "host_pool_name" {
  description = "Azure Virtual Desktop host pool name"
  value       = azurerm_virtual_desktop_host_pool.hostpool.name
}