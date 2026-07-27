# =============================================================================
# RESOURCES
# =============================================================================

# Create the Azure Compute Gallery that will store golden image versions.
resource "azurerm_shared_image_gallery" "gallery" {
  name                = var.gallery_name
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Azure Compute Gallery for AVD golden images"
  tags                = var.tags
}

# Create the Windows 11 Multi-Session image definition.
# Image versions are published to this definition in later phases.
resource "azurerm_shared_image" "image_definition" {
  name                = var.image_definition_name
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Windows multi-session golden image.
  os_type = "Windows"

  # Generation 2 is required for Windows 11.
  hyper_v_generation = "V2"

  # Metadata identifier used to reference this image definition.
  identifier {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
  }

  tags = var.tags
}