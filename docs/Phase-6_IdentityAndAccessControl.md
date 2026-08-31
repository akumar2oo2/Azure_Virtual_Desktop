# Phase 6 - Identity And Access Control

# 1. Purpose

Phase 6 introduces the identity foundation for the Azure Virtual Desktop platform.

The purpose of this phase is to establish Microsoft Entra ID groups that will be consumed by future Azure Virtual Desktop resources.

This phase intentionally remains lightweight.

The platform creates identity groups now and assigns permissions later when Azure Virtual Desktop resources exist.

This approach keeps the lab environment simple while maintaining enterprise-aligned design principles.

---

# 2. Scope

The following items are implemented during Phase 6:

```text
Identity Resource Group

Microsoft Entra ID Groups

Identity Terraform Module

Environment-Driven Identity Deployment
```

The following items are not implemented during Phase 6:

```text
RBAC Assignments

Desktop Virtualization User Role

Desktop Virtualization Contributor Role

Virtual Machine User Login

PIM

Conditional Access

Identity Governance

Access Packages

Dynamic Groups
```

These capabilities may be introduced in future phases if required.

---

# 3. Repository Structure

Phase 6 introduces the Identity module.

```text
Azure_Virtual_Desktop/
│
├── modules/
│   └── identity/
│       ├── versions.tf
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev.tfvars
│   ├── test.tfvars
│   └── prod.tfvars
│
├── locals.tf
├── variables.tf
├── outputs.tf
└── main.tf
```

---

# 4. Identity Architecture

The platform uses Microsoft Entra ID groups to establish a reusable identity model.

These groups become the identity foundation for:

```text
Azure Virtual Desktop

Monitoring

Session Host Administration

Future Platform Enhancements
```

No permissions are assigned during this phase.

Groups are created now and consumed later.

---

## Architecture Flow

```text
Microsoft Entra ID

        │

        ▼

AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk

        │

        ▼

Future Azure Virtual Desktop Resources

        │

        ▼

Future RBAC Assignments
```

---

# 5. Identity Resource Group Strategy

Each environment receives a dedicated identity resource group.

Although Microsoft Entra ID groups are tenant-level resources, a dedicated Identity Resource Group is created to maintain consistency across the platform architecture.

---

## DEV

```text
AK-AVD-DEV-ID-RG
```

---

## TEST

```text
AK-AVD-TEST-ID-RG
```

---

## PROD

```text
AK-AVD-PROD-ID-RG
```

---

## Purpose

The Identity Resource Group provides:

```text
Identity Workload Container

Future Identity Resources

Future RBAC Scope Alignment

Consistent Resource Group Strategy
```

---

# 6. Microsoft Entra ID Group Strategy

The platform uses three standard groups.

These groups are shared across future Azure Virtual Desktop workloads.

---

## Administrators Group

Pattern:

```text
AK-AVD-Admins
```

Purpose:

```text
Azure Virtual Desktop Administrators

Platform Administrators

Future Elevated Access Assignments
```

---

## Users Group

Pattern:

```text
AK-AVD-Users
```

Purpose:

```text
Azure Virtual Desktop End Users

Future Application Access Assignments

Future Desktop Assignments
```

---

## Helpdesk Group

Pattern:

```text
AK-AVD-Helpdesk
```

Purpose:

```text
Support Personnel

Operational Support

Future Platform Support Assignments
```

---

# 7. Identity Deployment Strategy

Identity deployment is optional.

The platform supports environments where Microsoft Entra groups are managed externally.

---

## Environment Configuration

Identity deployment is controlled through environment-specific tfvars files.

Example:

```hcl
deploy_identity = true
```

---

## Disabled Identity Deployment

Example:

```hcl
deploy_identity = false
```

When disabled:

```text
Identity Module Not Deployed

No Groups Created

Platform Continues To Deploy Successfully
```

---

# 8. Terraform Module Design

## Module

```text
modules/identity
```

---

## Purpose

Creates Microsoft Entra ID groups for future Azure Virtual Desktop workloads.

---

## Resources

```text
AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk
```

---

## Design Principles

```text
No Hardcoded Object IDs

Environment Optional

Reusable

Future Ready

Simple Lab Design
```

---

# 9. Inputs

The Identity module consumes the following inputs.

---

## Deploy Identity Flag

```hcl
variable "deploy_identity"
```

Purpose:

```text
Controls whether identity resources are deployed.
```

---

## Tags

```hcl
variable "tags"
```

Purpose:

```text
Applies platform-standard tagging.
```

---

# 10. Outputs

The Identity module exposes the following outputs.

---

## Administrators

```text
admin_group_id

admin_group_name
```

---

## Users

```text
user_group_id

user_group_name
```

---

## Helpdesk

```text
helpdesk_group_id

helpdesk_group_name
```

---

## Purpose Of Outputs

These outputs are consumed by future phases.

Examples:

```text
Azure Virtual Desktop

Application Assignments

RBAC Assignments

Monitoring Access
```

---

# 11. Future RBAC Design

RBAC assignments are intentionally excluded from Phase 6.

Future Azure Virtual Desktop resources do not yet exist.

Assigning permissions before resources exist creates unnecessary complexity.

RBAC will be introduced when there are actual resources requiring authorization.

---

## Future Examples

Potential future assignments may include:

```text
Desktop Virtualization User

Desktop Virtualization Contributor

Virtual Machine User Login

Virtual Machine Administrator Login
```

These assignments will be evaluated during future phases.

---

# 12. Terraform Root Module Strategy

Identity deployment is environment driven.

Example:

```hcl
module "identity" {
  count = var.deploy_identity ? 1 : 0

  source = "./modules/identity"

  tags = local.common_tags
}
```

This allows identity deployment to be:

```text
Enabled

Disabled

Environment Specific
```

without modifying module code.

---

# 13. Environment Strategy

The platform supports:

```text
DEV

TEST

PROD
```

Identity deployment may vary by environment.

Examples:

DEV

```hcl
deploy_identity = true
```

TEST

```hcl
deploy_identity = false
```

PROD

```hcl
deploy_identity = true
```

The platform remains functional regardless of identity deployment state.

---

# 14. Deployment Flow

```text
GitHub Actions

      │

      ▼

OIDC Authentication

      │

      ▼

Terraform Init

      │

      ▼

Terraform Plan

      │

      ▼

Identity Module

      │

      ▼

Identity Resource Group

      │

      ▼

AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk

      │

      ▼

Outputs Published
```

---

# 15. Validation Checklist

Verify:

```text
Identity Resource Group Created

Identity Module Created

AK-AVD-Admins Created

AK-AVD-Users Created

AK-AVD-Helpdesk Created

Terraform Validate Successful

Terraform Plan Successful

Terraform Apply Successful

Outputs Verified

No Hardcoded Object IDs
```

---

# 16. Exit Criteria

Phase 6 is complete when:

```text
Identity Resource Group Created

Identity Module Implemented

AK-AVD-Admins Created

AK-AVD-Users Created

AK-AVD-Helpdesk Created

Outputs Validated

Environment-Driven Deployment Working

Identity Deployment Can Be Disabled Through tfvars

No Hardcoded Object IDs
```

The platform is now prepared for Azure Virtual Desktop resource deployment.

---

# 17. Next Phase

Upon completion of Phase 6 the project moves to:

```text
Phase 7 - Azure Virtual Desktop Core
```

Phase 7 introduces:

```text
Workspace

Host Pool

Desktop Application Group

Remote Application Group

Azure Virtual Desktop Terraform Modules
```

Phase 7 establishes the Azure Virtual Desktop control plane.

Session Hosts are still not deployed during Phase 7.