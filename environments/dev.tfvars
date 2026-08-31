# Development Environment Configuration
# Used when the GitHub Actions workflow is executed with:
# environment = dev
#
# This file contains environment-specific values that Terraform
# uses during planning and deployment.

environment = "dev"

# Standard resource naming prefix.
project_prefix = "AK"

# Azure Virtual Desktop project name.
project_name = "AVD"

# Primary Azure region for development resources.
location = "centralindia"

# Image definition metadata (identifier only - not a marketplace pull).
image_publisher = "MicrosoftWindowsDesktop"
image_offer     = "Windows-11"
image_sku       = "win11-23h2-avd"

# Common resource tags.
tags = {
  AKProject = "AVD"
  Workload  = "ImageGallery"
}

# -----------------------------------------------------------------------------
# Phase 5 - Core Infrastructure configuration
# -----------------------------------------------------------------------------

vnet_address_space = [
  "10.10.0.0/16"
]

subnet_definitions = {
  sessionhosts = {
    address_prefixes = ["10.10.1.0/24"]
  }

  build = {
    address_prefixes = ["10.10.2.0/24"]
  }

  management = {
    address_prefixes = ["10.10.3.0/24"]
  }
}

# -----------------------------------------------------------------------------
# Phase 6 - Identity configuration
# -----------------------------------------------------------------------------

deploy_identity = false