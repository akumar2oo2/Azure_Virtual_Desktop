# Terraform Version and Provider Configuration
# Defines the supported Terraform version, required providers,
# and the remote backend used for state management.

terraform {

  required_version = ">= 1.8.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

  }

  # Backend settings are loaded during terraform init
  # using backend.hcl.
  backend "azurerm" {}

}