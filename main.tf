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

# =============================================================================
# RESOURCE GROUP - NETWORKING
# =============================================================================
# Creates the resource group that holds the networking resources.

module "network_resource_group" {
  source = "./modules/resource-group"

  resource_group_name = local.network_resource_group_name
  location            = var.location
  tags                = local.networking_tags
}

# =============================================================================
# NETWORKING
# =============================================================================
# Creates the Virtual Network, subnets, Network Security Groups,
# and subnet associations.

module "networking" {
  source = "./modules/networking"

  resource_group_name = module.network_resource_group.resource_group_name
  location            = var.location

  virtual_network_name = local.virtual_network_name

  vnet_address_space = var.vnet_address_space

  subnet_definitions = {
    sessionhosts = {
      name             = local.subnet_names.sessionhosts
      address_prefixes = var.subnet_definitions.sessionhosts.address_prefixes
    }

    build = {
      name             = local.subnet_names.build
      address_prefixes = var.subnet_definitions.build.address_prefixes
    }

    management = {
      name             = local.subnet_names.management
      address_prefixes = var.subnet_definitions.management.address_prefixes
    }
  }

  network_security_groups = {
    sessionhosts = {
      name = local.network_security_group_names.sessionhosts
    }

    build = {
      name = local.network_security_group_names.build
    }

    management = {
      name = local.network_security_group_names.management
    }
  }

  tags = local.networking_tags
}

# =============================================================================
# RESOURCE GROUP - IDENTITY
# =============================================================================
# Creates the resource group that supports the identity workload.

module "identity_resource_group" {
  count  = var.deploy_identity ? 1 : 0
  source = "./modules/resource-group"

  resource_group_name = local.identity_resource_group_name
  location            = var.location
  tags                = local.identity_tags
}

# =============================================================================
# IDENTITY
# =============================================================================
# Creates the Microsoft Entra ID groups used by future platform workloads.

module "identity" {
  count  = var.deploy_identity ? 1 : 0
  source = "./modules/identity"

  admin_group_name    = local.admin_group_name
  user_group_name     = local.user_group_name
  helpdesk_group_name = local.helpdesk_group_name
}