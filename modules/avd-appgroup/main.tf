# =============================================================================
# RESOURCES
# =============================================================================

# Create the Azure Virtual Desktop application group.
resource "azurerm_virtual_desktop_application_group" "appgroup" {
  name                = var.application_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  host_pool_id = var.host_pool_id
  type         = var.application_group_type

  friendly_name = var.application_group_friendly_name
  description   = "Azure Virtual Desktop Application Group"

  tags = var.tags
}

# Register the application group with the workspace.
resource "azurerm_virtual_desktop_workspace_application_group_association" "association" {
  workspace_id         = var.workspace_id
  application_group_id = azurerm_virtual_desktop_application_group.appgroup.id
}