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

# -----------------------------------------------------------------------------
# Phase 5 - Core Infrastructure outputs
# Consumed by future platform phases and used for deployment validation.
# -----------------------------------------------------------------------------

output "network_resource_group_id" {
  description = "Networking resource group ID"
  value       = module.network_resource_group.resource_group_id
}

output "network_resource_group_name" {
  description = "Networking resource group name"
  value       = module.network_resource_group.resource_group_name
}

output "network_resource_group_location" {
  description = "Networking resource group location"
  value       = module.network_resource_group.resource_group_location
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.networking.subnet_ids
}

output "network_security_group_ids" {
  description = "Map of Network Security Group IDs"
  value       = module.networking.network_security_group_ids
}

# -----------------------------------------------------------------------------
# Phase 6 - Identity outputs
# Consumed by future platform phases and used for deployment validation.
# -----------------------------------------------------------------------------

output "identity_resource_group_id" {
  description = "Identity resource group ID"
  value       = var.deploy_identity ? module.identity_resource_group[0].resource_group_id : null
}

output "identity_resource_group_name" {
  description = "Identity resource group name"
  value       = var.deploy_identity ? module.identity_resource_group[0].resource_group_name : null
}

output "admin_group_id" {
  description = "Administrators group ID"
  value       = var.deploy_identity ? module.identity[0].admin_group_id : null
}

output "admin_group_name" {
  description = "Administrators group name"
  value       = var.deploy_identity ? module.identity[0].admin_group_name : null
}

output "user_group_id" {
  description = "Users group ID"
  value       = var.deploy_identity ? module.identity[0].user_group_id : null
}

output "user_group_name" {
  description = "Users group name"
  value       = var.deploy_identity ? module.identity[0].user_group_name : null
}

output "helpdesk_group_id" {
  description = "Helpdesk group ID"
  value       = var.deploy_identity ? module.identity[0].helpdesk_group_id : null
}

output "helpdesk_group_name" {
  description = "Helpdesk group name"
  value       = var.deploy_identity ? module.identity[0].helpdesk_group_name : null
}

# -----------------------------------------------------------------------------
# Phase 7 - Azure Virtual Desktop outputs
# Consumed by future platform phases and used for deployment validation.
# -----------------------------------------------------------------------------

output "avd_resource_group_id" {
  description = "Azure Virtual Desktop resource group ID"
  value       = var.deploy_avd ? module.avd_resource_group[0].resource_group_id : null
}

output "avd_resource_group_name" {
  description = "Azure Virtual Desktop resource group name"
  value       = var.deploy_avd ? module.avd_resource_group[0].resource_group_name : null
}

output "workspace_id" {
  description = "Azure Virtual Desktop workspace ID"
  value       = var.deploy_avd ? module.avd_workspace[0].workspace_id : null
}

output "workspace_name" {
  description = "Azure Virtual Desktop workspace name"
  value       = var.deploy_avd ? module.avd_workspace[0].workspace_name : null
}

output "host_pool_ids" {
  description = "Map of Azure Virtual Desktop host pool IDs"

  value = var.deploy_avd ? {
    for key, hostpool in module.avd_hostpool :
    key => hostpool.host_pool_id
  } : {}
}

output "host_pool_names" {
  description = "Map of Azure Virtual Desktop host pool names"

  value = var.deploy_avd ? {
    for key, hostpool in module.avd_hostpool :
    key => hostpool.host_pool_name
  } : {}
}

output "application_group_ids" {
  description = "Map of Azure Virtual Desktop application group IDs"

  value = var.deploy_avd ? {
    for key, appgroup in module.avd_appgroup :
    key => appgroup.application_group_id
  } : {}
}

output "application_group_names" {
  description = "Map of Azure Virtual Desktop application group names"

  value = var.deploy_avd ? {
    for key, appgroup in module.avd_appgroup :
    key => appgroup.application_group_name
  } : {}
}

