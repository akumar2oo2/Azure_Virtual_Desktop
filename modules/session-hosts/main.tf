# =============================================================================
# NETWORK INTERFACES
# =============================================================================

# Create a dedicated Network Interface for each Session Host.
resource "azurerm_network_interface" "session_host_nics" {
  for_each = var.network_interface_names

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# =============================================================================
# SESSION HOST VIRTUAL MACHINES
# =============================================================================

# Create the Windows Session Host virtual machines from the Golden Image.
resource "azurerm_windows_virtual_machine" "session_hosts" {
  for_each = var.session_host_names

  name          = each.value
  computer_name = var.computer_names[each.key]

  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.session_hosts.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.session_host_nics[each.key].id
  ]

  source_image_id = var.image_id

  os_disk {
    name = "${each.value}-OSDISK"

    caching              = var.session_hosts.os_disk.caching
    storage_account_type = var.session_hosts.os_disk.storage_account_type
    disk_size_gb         = var.session_hosts.os_disk.disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }

  provision_vm_agent = true

  tags = var.tags
}

# =============================================================================
# MICROSOFT ENTRA ID JOIN
# =============================================================================

# Enable Microsoft Entra ID authentication on Session Hosts configured for Entra ID.
resource "azurerm_virtual_machine_extension" "entra_id_join" {
  for_each = var.session_hosts.join_type == "EntraID" ? var.session_host_names : {}

  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.session_hosts[each.key].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  settings = jsonencode({})

  tags = var.tags
}

# =============================================================================
# AZURE VIRTUAL DESKTOP REGISTRATION
# =============================================================================

# Install the Azure Virtual Desktop agents and register each Session Host
# with its corresponding Azure Virtual Desktop Host Pool.
resource "azurerm_virtual_machine_extension" "avd_registration" {
  for_each = var.session_host_names

  name                       = "AVDHostPoolRegistration"
  virtual_machine_id         = azurerm_windows_virtual_machine.session_hosts[each.key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.83"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl           = var.avd_registration_artifact_url
    configurationFunction = "Configuration.ps1\\AddSessionHost"

    properties = {
      hostPoolName = var.host_pool_name
      aadJoin      = var.session_hosts.join_type == "EntraID"
    }
  })

  protected_settings = jsonencode({
    properties = {
      registrationInfoToken = var.registration_token
    }
  })

  tags = var.tags

  depends_on = [
    azurerm_virtual_machine_extension.entra_id_join
  ]
}

# =============================================================================
# AZURE MONITOR AGENT
# =============================================================================

# Install the Azure Monitor Agent on Session Hosts where monitoring is enabled.
resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  for_each = var.session_hosts.monitoring.ama_enabled ? var.session_host_names : {}

  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.session_hosts[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  settings = jsonencode({})

  tags = var.tags

  depends_on = [
    azurerm_virtual_machine_extension.avd_registration
  ]
}

# =============================================================================
# DATA COLLECTION RULE ASSOCIATIONS
# =============================================================================

# Associate each enabled Data Collection Rule with every Session Host.
resource "azurerm_monitor_data_collection_rule_association" "dcr_associations" {
  for_each = var.session_hosts.monitoring.ama_enabled ? merge([
    for host_key, host_name in var.session_host_names : {
      for dcr_key, dcr_id in var.dcr_ids :
      "${host_key}-${dcr_key}" => {
        host_key = host_key
        dcr_key  = dcr_key
        dcr_id   = dcr_id
      }
    }
  ]...) : {}

  name                    = "assoc-${each.value.dcr_key}-${each.value.host_key}"
  target_resource_id      = azurerm_windows_virtual_machine.session_hosts[each.value.host_key].id
  data_collection_rule_id = each.value.dcr_id

  description = "Associates the ${each.value.dcr_key} Data Collection Rule with the Session Host."

  depends_on = [
    azurerm_virtual_machine_extension.azure_monitor_agent
  ]
}