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