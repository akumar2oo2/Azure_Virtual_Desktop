# =============================================================================
# LOCAL VALUES - Phase 3
# =============================================================================
# Naming is centralized in the root module so each per-component resource
# group is named consistently and the modules remain generic.

locals {
  # Uppercase environment token used inside Azure resource names (DEV, TEST, PROD).
  env_upper = upper(var.environment)

  # Image resource group name. Hyphens are valid for resource group names.
  image_resource_group_name = format(
    "%s-%s-%s-IMG-RG",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  # Azure Compute Gallery name.
  # Azure rejects hyphens in gallery names, so the documented form
  # (AK-AVD-DEV-ACG) is converted to underscores to stay valid.
  gallery_name = replace(
    format("%s-%s-%s-ACG", var.project_prefix, var.project_name, local.env_upper),
    "-",
    "_"
  )

  # Windows 11 Multi-Session image definition name. Hyphens are allowed here.
  image_definition_name = format("%s-WIN11-MS", var.project_prefix)

  # Merge platform tags with any caller-supplied tags.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "Phase-3-Image-Gallery"
  })
}

# =============================================================================
# LOCAL VALUES - Phase 5
# =============================================================================
# Naming is centralized in the root module so networking resources
# follow platform naming standards while modules remain generic.

locals {
  # Networking resource group name.
  network_resource_group_name = format(
    "%s-%s-%s-NET-RG",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  # Virtual Network name.
  virtual_network_name = format(
    "%s-%s-%s-VNET",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  # Subnet names.
  subnet_names = {
    sessionhosts = format("%s-%s-%s-SNET-SESSIONHOSTS", var.project_prefix, var.project_name, local.env_upper)
    build        = format("%s-%s-%s-SNET-BUILD", var.project_prefix, var.project_name, local.env_upper)
    management   = format("%s-%s-%s-SNET-MANAGEMENT", var.project_prefix, var.project_name, local.env_upper)
  }

  # Network Security Group names.
  network_security_group_names = {
    sessionhosts = format("%s-%s-%s-SH-NSG", var.project_prefix, var.project_name, local.env_upper)
    build        = format("%s-%s-%s-BUILD-NSG", var.project_prefix, var.project_name, local.env_upper)
    management   = format("%s-%s-%s-MGMT-NSG", var.project_prefix, var.project_name, local.env_upper)
  }

  # Phase 5 networking tags.
  networking_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "Phase-5-Core-Infrastructure"
  })
}

# =============================================================================
# LOCAL VALUES - Phase 6
# =============================================================================
# Naming is centralized in the root module so identity resources
# follow platform naming standards while modules remain generic.

locals {
  # Identity resource group name.
  identity_resource_group_name = format(
    "%s-%s-%s-ID-RG",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  # Microsoft Entra ID group names.
  admin_group_name = format(
    "%s-%s-Admins",
    var.project_prefix,
    var.project_name
  )

  user_group_name = format(
    "%s-%s-Users",
    var.project_prefix,
    var.project_name
  )

  helpdesk_group_name = format(
    "%s-%s-Helpdesk",
    var.project_prefix,
    var.project_name
  )

  # Phase 6 identity tags.
  identity_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "Phase-6-Identity"
  })
}

# =============================================================================
# LOCAL VALUES - Phase 7
# =============================================================================
# Naming is centralized in the root module so Azure Virtual Desktop resources
# follow platform naming standards while modules remain generic.

locals {
  # Azure Virtual Desktop resource group name.
  avd_resource_group_name = format(
    "%s-%s-%s-AVD-RG",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  # Azure Virtual Desktop workspace names.
  workspace_name = format(
    "%s-%s-%s-WS",
    var.project_prefix,
    var.project_name,
    local.env_upper
  )

  workspace_friendly_name = "AVD Workspace"

  # Azure Virtual Desktop host pool names.
  host_pool_names = {
    for key, pool in var.host_pools :
    key => format(
      "%s-%s-%s-HP-%s",
      var.project_prefix,
      var.project_name,
      local.env_upper,
      upper(pool.host_pool_name)
    )
  }

  # Azure Virtual Desktop application group names.
  application_group_names = {
    for key, pool in var.host_pools :
    key => (
      pool.application_group_type == "Desktop" ?
      format(
        "%s-%s-%s-DAG-%s",
        var.project_prefix,
        var.project_name,
        local.env_upper,
        upper(pool.host_pool_name)
      ) :
      format(
        "%s-%s-%s-RAG-%s",
        var.project_prefix,
        var.project_name,
        local.env_upper,
        upper(pool.host_pool_name)
      )
    )
  }

  application_group_friendly_names = {
    for key, pool in var.host_pools :
    key => (
      pool.application_group_type == "Desktop"
      ? "${title(lower(pool.host_pool_name))} Desktop"
      : "${title(lower(pool.host_pool_name))} Applications"
    )
  }

  # Phase 7 Azure Virtual Desktop tags.
  avd_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "Phase-7-AVD-Core"
  })
}
