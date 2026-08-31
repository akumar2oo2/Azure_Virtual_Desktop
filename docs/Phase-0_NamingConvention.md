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
AK-AVD-PROD-HP

AK-AVD-TEST-LAW
```

---

# 4. Bootstrap Resource Standards

The bootstrap resources are manually created before Terraform is introduced.

Terraform does not manage bootstrap resources.

---

## Terraform State Resource Group

```text
AK-RG-TFSTATE
```

---

## Terraform State Storage Account

```text
akavdtfstate
```

Storage account names must remain lowercase.

Purpose:

```text
Stores Terraform remote state files.
```

---

## Terraform State Container

```text
tfstate
```

Purpose:

```text
Stores environment-specific Terraform state files.
```

Examples:

```text
dev.tfstate

test.tfstate

prod.tfstate
```

---

## Package Repository Resource Group

```text
AK-RG-PKGS
```

Purpose:

```text
Stores package repository resources used by the Image Factory.
```

---

## Package Repository Storage Account

```text
akavdpackages
```

Storage account names must remain lowercase.

Purpose:

```text
Centralized package repository for Image Factory builds.
```

For this lab environment, installation packages required by the Image Factory are stored in Azure Storage.

Enterprise Note:

```text
In enterprise environments, a centralized package management platform such as JFrog Artifactory would typically be used for software distribution and version management.

For this lab, Azure Storage provides a simpler solution while still maintaining the centralized package repository pattern used by enterprise image factories.
```

---

## Package Repository Container

```text
packages
```

Purpose:

```text
Stores installation packages consumed during image builds.
```

Examples:

```text
FSLogix.zip
```

---

## App Registration

```text
AK-SPN-AVD
```

---

## Federated Credential

```text
AK-GitHub-OIDC
```

This federated credential is shared across:

```text
DEV

TEST

PROD
```

environments.

---

## App Registration

```text
AK-SPN-AVD
```

---

## Federated Credential

```text
AK-GitHub-OIDC
```

This federated credential is shared across:

```text
DEV

TEST

PROD
```

environments.

---

# 5. Resource Group Naming Standards

## Resource Group

Pattern:

```text
AK-AVD-<ENV>-<WORKLOAD>-RG
```

Examples:

```text
AK-AVD-DEV-NET-RG
AK-AVD-DEV-IMG-RG
AK-AVD-DEV-ID-RG
AK-AVD-DEV-AVD-RG
AK-AVD-DEV-MON-RG
AK-AVD-DEV-FSL-RG

AK-AVD-TEST-NET-RG
AK-AVD-TEST-IMG-RG
AK-AVD-TEST-ID-RG
AK-AVD-TEST-AVD-RG
AK-AVD-TEST-MON-RG
AK-AVD-TEST-FSL-RG

AK-AVD-PROD-NET-RG
AK-AVD-PROD-IMG-RG
AK-AVD-PROD-ID-RG
AK-AVD-PROD-AVD-RG
AK-AVD-PROD-MON-RG
AK-AVD-PROD-FSL-RG
```

---

## Workload Codes

```text
NET = Networking

IMG = Image Infrastructure

ID = Identity

AVD = Azure Virtual Desktop

MON = Monitoring

FSL = FSLogix Storage
```

---

# 6. Azure Resource Naming Standards

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
AK-AVD-<ENV>-<PURPOSE>-NSG
```

Examples:

```text
AK-AVD-DEV-SH-NSG
AK-AVD-DEV-BUILD-NSG
AK-AVD-DEV-MGMT-NSG

AK-AVD-TEST-SH-NSG
AK-AVD-TEST-BUILD-NSG
AK-AVD-TEST-MGMT-NSG

AK-AVD-PROD-SH-NSG
AK-AVD-PROD-BUILD-NSG
AK-AVD-PROD-MGMT-NSG
```

Purpose codes:

```test
SH = Session Hosts
BUILD = Image Factory Build Resources
MGMT = Management Resources
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

# 7. Azure Compute Gallery Standards

## Azure Compute Gallery

Pattern:

```text
AK-AVD-<ENV>-ACG
```

Examples:

```text
AK-AVD-DEV-ACG

AK-AVD-TEST-ACG

AK-AVD-PROD-ACG
```

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

# 8. Azure Virtual Desktop Naming Standards

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

# 9. Session Host Naming Standards

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

# 10. Monitoring Naming Standards

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

# 11. Identity Naming Standards

## App Registration

Pattern:

```text
AK-SPN-AVD
```

---

## Federated Credential

Pattern:

```text
AK-GitHub-OIDC
```

Environment-specific OIDC credentials are prohibited.

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

# 12. Terraform Standards

## Local Values

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
name = "AK-AVD-DEV-NET-RG"
```

Good:

```hcl
name = "${local.prefix}-${local.workload}-${local.environment}-NET-RG"
```

---

# 13. GitHub Standards

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

---

# 14. Terraform State Standards

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

# 15. Tagging Standards

All resources must include:

```hcl
tags = {
  Project     = "Azure Virtual Desktop"
  Environment = var.environment
  Owner       = "Ayush Kumar"
  ManagedBy   = "Terraform"
}
```

---

# 16. Naming Convention Summary

## Bootstrap Resources

```text
AK-RG-TFSTATE

akavdtfstate

tfstate

AK-RG-PKGS

akavdpackages

packages

AK-SPN-AVD

AK-GitHub-OIDC
```

---

## Environment Resource Groups

```text
AK-AVD-DEV-NET-RG
AK-AVD-DEV-IMG-RG
AK-AVD-DEV-ID-RG
AK-AVD-DEV-AVD-RG
AK-AVD-DEV-MON-RG
AK-AVD-DEV-FSL-RG

AK-AVD-TEST-NET-RG
AK-AVD-TEST-IMG-RG
AK-AVD-TEST-ID-RG
AK-AVD-TEST-AVD-RG
AK-AVD-TEST-MON-RG
AK-AVD-TEST-FSL-RG

AK-AVD-PROD-NET-RG
AK-AVD-PROD-IMG-RG
AK-AVD-PROD-ID-RG
AK-AVD-PROD-AVD-RG
AK-AVD-PROD-MON-RG
AK-AVD-PROD-FSL-RG
```

---

## Gallery Examples

```text
AK-AVD-DEV-ACG

AK-AVD-TEST-ACG

AK-AVD-PROD-ACG
```

---

## Image Definition

```text
AK-WIN11-MS
```

These standards shall be applied consistently across all platform resources, modules, workflows, and future enhancements.