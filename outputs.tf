# Validation Outputs
# Exposes information returned by the authenticated Azure identity.
# These outputs help verify that Terraform is communicating
# successfully with Azure through OIDC.

#output "tenant_id" {
#  value = data.azurerm_client_config.current.tenant_id
#  sensitive = true
#}

#output "subscription_id" {
#  value = data.azurerm_client_config.current.subscription_id
#  sensitive = true
#}

#output "client_id" {
#  value = data.azurerm_client_config.current.client_id
#  sensitive = true
#}

# -----------------------------------------------------------------------------
# Phase 3 - Image Gallery outputs
# Consumed later by Phase 4 (Image Factory) and Phase 9 (Session Hosts).
# -----------------------------------------------------------------------------

output "image_resource_group_name" {
  description = "Name of the image resource group"
  value       = module.image_resource_group.resource_group_name
}

output "gallery_id" {
  description = "Azure Compute Gallery ID"
  value       = module.image_gallery.gallery_id
}

output "gallery_name" {
  description = "Azure Compute Gallery name"
  value       = module.image_gallery.gallery_name
}

output "image_definition_id" {
  description = "Image definition ID"
  value       = module.image_gallery.image_definition_id
}

output "image_definition_name" {
  description = "Image definition name"
  value       = module.image_gallery.image_definition_name
}