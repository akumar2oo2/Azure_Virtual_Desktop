# Outputs consumed by Phase 4 (Image Factory) and Phase 9 (Session Hosts).

output "gallery_id" {
  description = "Azure Compute Gallery ID"
  value       = azurerm_shared_image_gallery.gallery.id
}

output "gallery_name" {
  description = "Azure Compute Gallery name"
  value       = azurerm_shared_image_gallery.gallery.name
}

output "image_definition_id" {
  description = "Image definition ID"
  value       = azurerm_shared_image.image_definition.id
}

output "image_definition_name" {
  description = "Image definition name"
  value       = azurerm_shared_image.image_definition.name
}