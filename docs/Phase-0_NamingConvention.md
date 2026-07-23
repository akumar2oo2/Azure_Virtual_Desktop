# Azure Virtual Desktop Enterprise Platform Naming Convention

# 1. Purpose

This document defines the naming standards used throughout the Azure Virtual Desktop Enterprise Platform.

Consistent naming is required to ensure:

- Predictable deployments
- Operational consistency
- Easier troubleshooting
- Standardized monitoring
- Simpler automation
- Long-term maintainability

All resources, modules, workflows, documentation, and environments must comply with these standards.

---

# 2. Standard Naming Components

## Prefix

The platform prefix is:

```text
AK
```

Meaning:

```text
Ayush Kumar
```

This prefix is applied to all Azure resources created by this platform.

---

## Workload

The workload identifier is:

```text
AVD
```

Meaning:

```text
Azure Virtual Desktop
```

---

## Environment

Only the following environments are permitted:

```text
DEV
TEST
PROD
```

Environment values must always be uppercase.

---

# 3. Standard Resource Naming Pattern

The standard naming format is:

```text
<Prefix>-<Workload>-<Environment>-<ResourceType>
```

Examples:

```text
AK-AVD-DEV-RG

AK-AVD-PROD-HP

AK-AVD-TEST-LAW
```

---

# 4. Bootstrap Resource Standards

The bootstrap resources are manually created before Terraform is introduced.

Terraform does not manage bootstrap resources.

---

## Resource Group

```text
AK-RG-TFSTATE
```

---

## Storage Account

```text
akavdtfstate
```

Storage account names must remain lowercase.

---

## Blob Container

```text
tfstate
```

---

## App Registration

```text
AK-SPN-AVD
```

Purpose:

```text
Terraform Deployments

Image Factory

Azure Virtual Desktop

Monitoring

Future Platform Components
```

---

## Federated Credential

```text
AK-GitHub-OIDC
```

Purpose:

```text
GitHub Actions Authentication
```

This federated credential is shared across:

```text
DEV

TEST

PROD
```

environments.

Environment selection is controlled through the workflow parameter and not through separate federated credentials.

---

# 5. Azure Resource Naming Standards

## Resource Group

Pattern:

```text
AK-AVD-<ENV>-RG
```

Examples:

```text
AK-AVD-DEV-RG

AK-AVD-TEST-RG

AK-AVD-PROD-RG
```

---

## Virtual Network

Pattern:

```text
AK-AVD-<ENV>-VNET
```

Examples:

```text
AK-AVD-DEV-VNET

AK-AVD-PROD-VNET
```

---

## Subnet

Pattern:

```text
AK-AVD-<ENV>-SNET-<PURPOSE>
```

Examples:

```text
AK-AVD-DEV-SNET-SESSIONHOSTS

AK-AVD-DEV-SNET-BUILD

AK-AVD-DEV-SNET-MANAGEMENT
```

---

## Network Security Group

Pattern:

```text
AK-AVD-<ENV>-NSG
```

Examples:

```text
AK-AVD-DEV-NSG

AK-AVD-PROD-NSG
```

---

## Route Table

Pattern:

```text
AK-AVD-<ENV>-RT
```

Examples:

```text
AK-AVD-DEV-RT

AK-AVD-PROD-RT
```

---

# 6. Azure Compute Gallery Standards

## Azure Compute Gallery

Pattern:

```text
AK-AVD-ACG
```

Example:

```text
AK-AVD-ACG
```

A single gallery supports all environments.

---

## Image Definition

Pattern:

```text
AK-WIN11-MS
```

Meaning:

```text
AK

Windows 11

Multi-Session
```

Future examples:

```text
AK-WIN11-SINGLE

AK-WIN2025-RDS
```

---

## Image Versioning Standard

Pattern:

```text
Major.Minor.Patch
```

Examples:

```text
1.0.0

1.1.0

1.1.1

2.0.0
```

---

### Major Version

Used for:

```text
Operating System Upgrades

Major Platform Changes

Architectural Redesigns
```

---

### Minor Version

Used for:

```text
New Features

New Applications

Configuration Enhancements
```

---

### Patch Version

Used for:

```text
Security Updates

Bug Fixes

Maintenance Releases
```

---

# 7. Azure Virtual Desktop Naming Standards

## Workspace

Pattern:

```text
AK-AVD-<ENV>-WS
```

Examples:

```text
AK-AVD-DEV-WS

AK-AVD-PROD-WS
```

---

## Host Pool

Pattern:

```text
AK-AVD-<ENV>-HP
```

Examples:

```text
AK-AVD-DEV-HP

AK-AVD-PROD-HP
```

---

## Desktop Application Group

Pattern:

```text
AK-AVD-<ENV>-DAG
```

Examples:

```text
AK-AVD-DEV-DAG

AK-AVD-PROD-DAG
```

---

## Remote Application Group

Pattern:

```text
AK-AVD-<ENV>-RAG
```

Examples:

```text
AK-AVD-DEV-RAG

AK-AVD-PROD-RAG
```

---

# 8. Session Host Naming Standards

## Session Host Virtual Machine

Pattern:

```text
AK-AVD-<ENV>-SHXX
```

Examples:

```text
AK-AVD-DEV-SH01

AK-AVD-DEV-SH02

AK-AVD-PROD-SH01
```

Where:

```text
SH = Session Host
```

---

## Network Interface

Pattern:

```text
AK-AVD-<ENV>-NICXX
```

Examples:

```text
AK-AVD-DEV-NIC01

AK-AVD-PROD-NIC01
```

---

## Managed Disk

Pattern:

```text
AK-AVD-<ENV>-DISKXX
```

Examples:

```text
AK-AVD-DEV-DISK01

AK-AVD-PROD-DISK01
```

---

# 9. Monitoring Naming Standards

## Log Analytics Workspace

Pattern:

```text
AK-AVD-<ENV>-LAW
```

Examples:

```text
AK-AVD-DEV-LAW

AK-AVD-PROD-LAW
```

---

## Data Collection Rule

Pattern:

```text
AK-AVD-<ENV>-DCR
```

Examples:

```text
AK-AVD-DEV-DCR

AK-AVD-PROD-DCR
```

---

## Workbook

Pattern:

```text
AK-AVD-<ENV>-WB
```

Examples:

```text
AK-AVD-DEV-WB

AK-AVD-PROD-WB
```

---

## Action Group

Pattern:

```text
AK-AVD-<ENV>-AG
```

Examples:

```text
AK-AVD-DEV-AG

AK-AVD-PROD-AG
```

---

# 10. Identity Naming Standards

## App Registration

Pattern:

```text
AK-SPN-AVD
```

Example:

```text
AK-SPN-AVD
```

---

## Federated Credential

Pattern:

```text
AK-GitHub-OIDC
```

Example:

```text
AK-GitHub-OIDC
```

Environment-specific OIDC credentials are prohibited.

A single federated credential is used across all deployment environments.

---

## Azure AD Groups

### Administrators

```text
AK-AVD-Admins
```

### Users

```text
AK-AVD-Users
```

### Helpdesk

```text
AK-AVD-Helpdesk
```

---

# 11. Terraform Standards

## Local Values

The root module must contain:

```hcl
locals {
  prefix      = "AK"
  workload    = "AVD"
  environment = upper(var.environment)
}
```

---

## Hardcoded Names

Hardcoded names are prohibited.

Bad:

```hcl
name = "AK-AVD-DEV-RG"
```

Good:

```hcl
name = "${local.prefix}-${local.workload}-${local.environment}-RG"
```

---

# 12. GitHub Standards

## Repository Name

```text
Azure_Virtual_Desktop
```

---

## GitHub Environments

Allowed:

```text
dev

test

prod
```

Not allowed:

```text
development

qa

uat

production
```

---

## Workflow Files

Terraform:

```text
terraform-plan.yml

terraform-apply.yml
```

Image Factory:

```text
build-image.yml
```

Future Workflows:

```text
release-image.yml

destroy-environment.yml
```

---

# 13. Terraform State Standards

## State File Naming

Pattern:

```text
<environment>.tfstate
```

Examples:

```text
dev.tfstate

test.tfstate

prod.tfstate
```

---

# 14. Tagging Standards

All resources must include:

```hcl
tags = {
  Project     = "Azure Virtual Desktop"
  Environment = var.environment
  Owner       = "Ayush Kumar"
  ManagedBy   = "Terraform"
}
```

Additional tags may be added as required by future governance requirements.

---

# 15. Naming Convention Summary

## Global Values

```text
Prefix      = AK

Workload    = AVD

Environments = DEV | TEST | PROD
```

---

## Bootstrap Resources

```text
AK-RG-TFSTATE

akavdtfstate

tfstate

AK-SPN-AVD

AK-GitHub-OIDC
```

---

## Core Resource Examples

```text
AK-AVD-DEV-RG

AK-AVD-DEV-VNET

AK-AVD-DEV-SNET-SESSIONHOSTS

AK-AVD-DEV-NSG

AK-AVD-DEV-HP

AK-AVD-DEV-WS

AK-AVD-DEV-DAG

AK-AVD-DEV-LAW

AK-AVD-DEV-WB

AK-AVD-DEV-SH01
```

These standards shall be applied consistently across all platform resources, modules, workflows, and future enhancements.