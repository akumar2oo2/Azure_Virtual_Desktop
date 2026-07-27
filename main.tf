# Phase 1B Validation Configuration
# Retrieves information about the authenticated Azure identity.
# This confirms that OIDC authentication is working correctly
# without deploying any Azure resources.

#data "azurerm_client_config" "current" {}

# =============================================================================
# RESOURCE GROUP - IMAGE
# =============================================================================
# Creates the resource group that holds the Azure Compute Gallery.

module "image_resource_group" {
  source = "./modules/resource-group"

  resource_group_name = local.image_resource_group_name
  location            = var.location
  tags                = local.common_tags
}

# =============================================================================
# IMAGE GALLERY
# =============================================================================
# Creates the Compute Gallery and the Windows 11 Multi-Session image
# definition. Consumes the resource group output above.

module "image_gallery" {
  source = "./modules/image-gallery"

  resource_group_name   = module.image_resource_group.resource_group_name
  location              = var.location
  gallery_name          = local.gallery_name
  image_definition_name = local.image_definition_name

  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku

  tags = local.common_tags
}