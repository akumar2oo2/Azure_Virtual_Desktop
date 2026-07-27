# Production Environment Configuration
# Used when the GitHub Actions workflow is executed with:
# environment = prod
#
# This file contains environment-specific values that Terraform
# uses during planning and deployment.

environment = "prod"

# Standard resource naming prefix.
project_prefix = "AK"

# Azure Virtual Desktop project name.
project_name = "AVD"

# Primary Azure region for production resources.
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