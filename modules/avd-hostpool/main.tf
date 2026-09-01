# =============================================================================
# RESOURCES
# =============================================================================

# Create the Azure Virtual Desktop host pool.
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                = var.host_pool_name
  location            = var.location
  resource_group_name = var.resource_group_name

  friendly_name = var.host_pool_name

  type = var.host_pool_type

  load_balancer_type = (
    var.host_pool_type == "Personal"
    ? "Persistent"
    : var.load_balancer_type
  )

  personal_desktop_assignment_type = (
    var.host_pool_type == "Personal"
    ? var.personal_desktop_assignment_type
    : null
  )

  validate_environment = false

  tags = var.tags
}