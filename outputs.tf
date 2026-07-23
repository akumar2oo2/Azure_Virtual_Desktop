# Validation Outputs
# Exposes information returned by the authenticated Azure identity.
# These outputs help verify that Terraform is communicating
# successfully with Azure through OIDC.

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}