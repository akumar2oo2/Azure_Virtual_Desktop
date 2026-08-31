# =============================================================================
# RESOURCES
# =============================================================================

# Create the Microsoft Entra ID administrators group.
resource "azuread_group" "admins" {
  display_name     = var.admin_group_name
  security_enabled = true
}

# Create the Microsoft Entra ID users group.
resource "azuread_group" "users" {
  display_name     = var.user_group_name
  security_enabled = true
}

# Create the Microsoft Entra ID helpdesk group.
resource "azuread_group" "helpdesk" {
  display_name     = var.helpdesk_group_name
  security_enabled = true
}