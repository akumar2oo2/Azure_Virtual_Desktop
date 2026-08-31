# Outputs exposed for consumption by other modules and the root module.

output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value = {
    for key, subnet in azurerm_subnet.subnets :
    key => subnet.id
  }
}

output "network_security_group_ids" {
  description = "Map of Network Security Group IDs"
  value = {
    for key, nsg in azurerm_network_security_group.nsgs :
    key => nsg.id
  }
}