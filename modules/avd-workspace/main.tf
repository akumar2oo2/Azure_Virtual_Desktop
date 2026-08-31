# =============================================================================
# RESOURCES
# =============================================================================

# Create the Azure Virtual Desktop workspace.
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  friendly_name = var.workspace_friendly_name
  description   = "Azure Virtual Desktop Workspace"

  tags = var.tags
}