# Outputs exposed for consumption by other modules and the root module.

output "session_host_ids" {
  description = "Map of Session Host virtual machine IDs"

  value = {
    for key, session_host in azurerm_windows_virtual_machine.session_hosts :
    key => session_host.id
  }
}

output "session_host_names" {
  description = "Map of Session Host virtual machine names"

  value = {
    for key, session_host in azurerm_windows_virtual_machine.session_hosts :
    key => session_host.name
  }
}

output "network_interface_ids" {
  description = "Map of Session Host Network Interface IDs"

  value = {
    for key, network_interface in azurerm_network_interface.session_host_nics :
    key => network_interface.id
  }
}

output "network_interface_names" {
  description = "Map of Session Host Network Interface names"

  value = {
    for key, network_interface in azurerm_network_interface.session_host_nics :
    key => network_interface.name
  }
}