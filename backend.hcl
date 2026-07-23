# Terraform remote state storage configuration

resource_group_name  = "AK-RG-TFSTATE"
storage_account_name = "akavdtfstate"
container_name       = "tfstate"

# Use OIDC instead of client secrets
use_oidc = true