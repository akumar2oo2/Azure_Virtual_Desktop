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

# =============================================================================
# RESOURCE GROUP - AZURE VIRTUAL DESKTOP
# =============================================================================
# Creates the resource group that hosts Azure Virtual Desktop resources.

module "avd_resource_group" {
  count  = var.deploy_avd ? 1 : 0
  source = "./modules/resource-group"

  resource_group_name = local.avd_resource_group_name
  location            = var.location
  tags                = local.avd_tags
}

# =============================================================================
# AZURE VIRTUAL DESKTOP WORKSPACE
# =============================================================================
# Creates the Azure Virtual Desktop workspace.

module "avd_workspace" {
  count  = var.deploy_avd ? 1 : 0
  source = "./modules/avd-workspace"

  resource_group_name     = module.avd_resource_group[0].resource_group_name
  location                = var.location
  workspace_name          = local.workspace_name
  workspace_friendly_name = local.workspace_friendly_name

  tags = local.avd_tags
}

# =============================================================================
# AZURE VIRTUAL DESKTOP HOST POOLS
# =============================================================================
# Creates Azure Virtual Desktop host pools.

module "avd_hostpool" {
  for_each = var.deploy_avd ? var.host_pools : {}

  source = "./modules/avd-hostpool"

  resource_group_name = module.avd_resource_group[0].resource_group_name
  location            = var.location

  host_pool_name     = local.host_pool_names[each.key]
  host_pool_type     = each.value.host_pool_type
  load_balancer_type = each.value.load_balancer_type

  personal_desktop_assignment_type = each.value.personal_desktop_assignment_type

  tags = local.avd_tags
}

# =============================================================================
# AZURE VIRTUAL DESKTOP APPLICATION GROUPS
# =============================================================================
# Creates Azure Virtual Desktop application groups and registers them
# with the workspace.

module "avd_appgroup" {
  for_each = var.deploy_avd ? var.host_pools : {}

  source = "./modules/avd-appgroup"

  resource_group_name = module.avd_resource_group[0].resource_group_name
  location            = var.location

  host_pool_id = module.avd_hostpool[each.key].host_pool_id
  workspace_id = module.avd_workspace[0].workspace_id

  application_group_name          = local.application_group_names[each.key]
  application_group_friendly_name = local.application_group_friendly_names[each.key]
  application_group_type          = each.value.application_group_type

  tags = local.avd_tags
}

# =============================================================================
# RESOURCE GROUP - MONITORING
# =============================================================================
# Creates the resource group that hosts monitoring resources.

module "monitoring_resource_group" {
  count  = var.deploy_monitoring ? 1 : 0
  source = "./modules/resource-group"

  resource_group_name = local.monitoring_resource_group_name
  location            = var.location
  tags                = local.monitoring_tags
}

# =============================================================================
# MONITORING PLATFORM
# =============================================================================
# Creates the monitoring foundation for Azure Virtual Desktop.

module "monitoring" {
  count  = var.deploy_monitoring ? 1 : 0
  source = "./modules/monitoring"

  resource_group_name = module.monitoring_resource_group[0].resource_group_name
  location            = var.location

  law_name = local.law_name

  monitoring = merge(
    var.monitoring,
    {
      dcrs = {
        for key, dcr in var.monitoring.dcrs :
        key => merge(
          dcr,
          {
            name = local.dcr_names[key]
          }
        )
      }

      workbooks = {
        for key, workbook in var.monitoring.workbooks :
        key => merge(
          workbook,
          {
            workbook_id = local.workbook_ids[key]
          }
        )
      }

      action_groups = {
        for key, action_group in var.monitoring.action_groups :
        key => merge(
          action_group,
          {
            name = local.action_group_names[key]
          }
        )
      }

      alerts = {
        for key, alert in var.monitoring.alerts :
        key => merge(
          alert,
          {
            name         = local.alert_names[key]
            display_name = local.alert_names[key]
            description  = local.alert_names[key]
          }
        )
      }
    }
  )

  tags = local.monitoring_tags
}

# =============================================================================
# SESSION HOST GOLDEN IMAGE VERSIONS
# =============================================================================
# Resolves the Azure Compute Gallery image version selected for each
# Host Pool with Session Host deployment enabled.

data "azurerm_shared_image_version" "session_host_images" {
  for_each = local.enabled_session_host_pools

  name                = each.value.session_hosts.image.version
  image_name          = each.value.session_hosts.image.definition
  gallery_name        = module.image_gallery.gallery_name
  resource_group_name = module.image_resource_group.resource_group_name
}

# =============================================================================
# SESSION HOST REGISTRATION TOKEN ROTATION
# =============================================================================
# Maintains a stable registration-token lifecycle for each Host Pool with
# Session Host deployment enabled.

resource "time_rotating" "session_host_registration" {
  for_each = local.enabled_session_host_pools

  rotation_days = 29
}

# =============================================================================
# SESSION HOST REGISTRATION INFORMATION
# =============================================================================
# Generates temporary registration information for each Host Pool and renews
# the token through the controlled rotation lifecycle.

resource "azurerm_virtual_desktop_host_pool_registration_info" "session_hosts" {
  for_each = local.enabled_session_host_pools

  hostpool_id     = module.avd_hostpool[each.key].host_pool_id
  expiration_date = time_rotating.session_host_registration[each.key].rotation_rfc3339
}

# =============================================================================
# SESSION HOSTS
# =============================================================================
# Deploys Session Hosts for each enabled Azure Virtual Desktop Host Pool.

module "session_hosts" {
  for_each = local.enabled_session_host_pools

  source = "./modules/session-hosts"

  resource_group_name = module.avd_resource_group[0].resource_group_name
  location            = var.location
  environment         = var.environment

  host_pool_key  = each.key
  host_pool_id   = module.avd_hostpool[each.key].host_pool_id
  host_pool_name = module.avd_hostpool[each.key].host_pool_name

  session_hosts = each.value.session_hosts

  session_host_names      = local.session_host_names[each.key]
  computer_names          = local.computer_names[each.key]
  network_interface_names = local.network_interface_names[each.key]

  subnet_id = module.networking.subnet_ids[
    each.value.session_hosts.network.subnet_key
  ]

  image_id = data.azurerm_shared_image_version.session_host_images[
    each.key
  ].id

  dcr_ids = {
    for dcr_key in each.value.session_hosts.monitoring.dcr_keys :
    dcr_key => module.monitoring[0].dcr_ids[dcr_key]
  }

  registration_token = azurerm_virtual_desktop_host_pool_registration_info.session_hosts[
    each.key
  ].token

  admin_username = var.session_host_admin_username
  admin_password = var.session_host_admin_password

  avd_registration_artifact_url = var.avd_registration_artifact_url

  tags = local.session_host_tags
}