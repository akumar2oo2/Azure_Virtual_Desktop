# Phase 1B Validation Configuration
# Retrieves information about the authenticated Azure identity.
# This confirms that OIDC authentication is working correctly
# without deploying any Azure resources.

data "azurerm_client_config" "current" {}