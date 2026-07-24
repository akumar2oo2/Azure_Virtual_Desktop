# Azure Virtual Desktop Enterprise Platform Module Contracts

# 1. Purpose

This document defines the standards, responsibilities, inputs, outputs, and dependencies for all Terraform modules used within the Azure Virtual Desktop Enterprise Platform.

The purpose of these contracts is to:

- Standardize module design
- Improve maintainability
- Improve reusability
- Reduce future refactoring
- Define clear module boundaries
- Establish repository-wide Terraform standards

This document is considered the source of truth for Terraform module development.

---

# 2. Module Design Principles

## Principle 1 - Self Contained Modules

Modules must be self-contained.

Modules are responsible only for the resources they create.

Modules must not depend on internal resources from other modules.

Allowed:

```hcl
variable "subnet_id"
```

Not Allowed:

```hcl
module.networking.subnet_id
```

inside module code.

---

## Principle 2 - Variables And Outputs

Modules communicate only through:

```text
Variables

Outputs
```

No direct module references are permitted inside module implementations.

---

## Principle 3 - No Hardcoded Values

Hardcoded values are prohibited.

Bad:

```hcl
name = "AK-AVD-DEV-RG"
```

Good:

```hcl
name = local.resource_group_name
```

---

## Principle 4 - Tag Support

All modules must support tagging.

Each module must accept:

```hcl
variable "tags"
```

---

## Principle 5 - Documentation Driven Development

Module implementation must follow approved documentation.

Phase documents are the authoritative documentation source.

Examples:

```text
modules/image-gallery
→ Phase-3_AzureComputeGallery.md

modules/networking
→ Phase-5_CoreInfrastructure.md

modules/session-hosts
→ Phase-9_SessionHosts.md
```

---

# 3. Module Structure Standard

Every module must follow the same structure.

```text
module-name/

├── versions.tf
├── main.tf
├── variables.tf
└── outputs.tf
```

---

## versions.tf

Purpose:

```text
Terraform Provider Requirements

Terraform Version Requirements
```

---

## main.tf

Purpose:

```text
Resource Definitions
```

---

## variables.tf

Purpose:

```text
Module Inputs
```

---

## outputs.tf

Purpose:

```text
Module Outputs
```

---

# 4. Terraform Standards

## Variable Requirements

Every variable must include:

```hcl
description

type
```

Example:

```hcl
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}
```

---

## Output Requirements

Any reusable value must be exposed as an output.

Examples:

```hcl
output "resource_group_id"

output "host_pool_id"

output "workspace_id"
```

---

## Comment Standards

All comments must be professional.

Allowed:

```hcl
# Create Azure Virtual Desktop Host Pool
```

Not Allowed:

```hcl
# Magic happens here
```

---

## Section Header Standards

Terraform files should use consistent section headers.

Example:

```hcl
# =============================================================================
# LOCAL VALUES
# =============================================================================

# =============================================================================
# RESOURCES
# =============================================================================

# =============================================================================
# OUTPUTS
# =============================================================================
```

---

# 5. Global Module Inputs

Most modules will consume:

```hcl
prefix

environment

location

resource_group_name

tags
```

These values should remain consistent across the platform.

---

# 6. Root Module Responsibilities

The root module is responsible for:

```text
Module Orchestration

Dependency Handling

Environment Selection

Variable Assignment
```

Modules are responsible only for their individual workloads.

---

# 7. Resource Group Module Contract

## Module

```text
modules/resource-group
```

---

## Purpose

Creates Azure Resource Groups.

---

## Inputs

```text
prefix

environment

location

tags
```

---

## Outputs

```text
resource_group_id

resource_group_name

resource_group_location
```

---

## Dependencies

```text
None
```

---

# 8. Networking Module Contract

## Module

```text
modules/networking
```

---

## Purpose

Creates networking resources.

---

## Resources

```text
Virtual Network

Subnets

Network Security Groups

Route Tables (Optional)
```

---

## Inputs

```text
resource_group_name

location

vnet_address_space

subnet_definitions

tags
```

---

## Outputs

```text
vnet_id

vnet_name

subnet_ids

nsg_id
```

---

## Dependencies

```text
resource-group
```

---

# 9. Identity Module Contract

## Module

```text
modules/identity
```

---

## Purpose

Creates identity resources and RBAC assignments.

---

## Resources

```text
AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk
```

---

## Inputs

```text
scope_ids

tags
```

---

## Outputs

```text
admin_group_id

user_group_id

helpdesk_group_id
```

---

## Dependencies

```text
resource-group
```

---

# 10. Image Gallery Module Contract

## Module

```text
modules/image-gallery
```

---

## Purpose

Creates Azure Compute Gallery resources.

---

## Resources

```text
Azure Compute Gallery

Image Definition
```

---

## Inputs

```text
resource_group_name

location

gallery_name

image_definition_name

tags
```

---

## Outputs

```text
gallery_id

gallery_name

image_definition_id

image_definition_name
```

---

## Dependencies

```text
resource-group
```

---

# 11. Monitoring Module Contract

## Module

```text
modules/monitoring
```

---

## Purpose

Creates monitoring resources.

---

## Resources

```text
Log Analytics Workspace

Data Collection Rules

Diagnostic Settings

Workbooks

Action Groups

Alerts
```

---

## Inputs

```text
resource_group_name

location

tags
```

---

## Outputs

```text
log_analytics_workspace_id

data_collection_rule_id

workbook_id

action_group_id
```

---

## Dependencies

```text
resource-group
```

---

# 12. AVD Workspace Module Contract

## Module

```text
modules/avd-workspace
```

---

## Purpose

Creates Azure Virtual Desktop Workspace.

---

## Inputs

```text
resource_group_name

location

workspace_name

tags
```

---

## Outputs

```text
workspace_id

workspace_name
```

---

## Dependencies

```text
resource-group
```

---

# 13. AVD Host Pool Module Contract

## Module

```text
modules/avd-hostpool
```

---

## Purpose

Creates Azure Virtual Desktop Host Pool.

---

## Inputs

```text
resource_group_name

location

host_pool_name

host_pool_type

load_balancer_type

tags
```

---

## Outputs

```text
host_pool_id

host_pool_name

registration_token
```

---

## Dependencies

```text
resource-group
```

---

# 14. AVD Application Group Module Contract

## Module

```text
modules/avd-appgroup
```

---

## Purpose

Creates Desktop and Remote Application Groups.

---

## Inputs

```text
host_pool_id

resource_group_name

location

application_group_type

tags
```

---

## Outputs

```text
application_group_id

application_group_name
```

---

## Dependencies

```text
avd-hostpool
```

---

# 15. Session Hosts Module Contract

## Module

```text
modules/session-hosts
```

---

## Purpose

Deploys Azure Virtual Desktop Session Hosts using Azure Compute Gallery images.

---

## Inputs

```text
host_pool_id

subnet_id

image_definition_id

image_version

session_host_count

vm_size

tags
```

---

## Outputs

```text
session_host_ids

session_host_names

network_interface_ids
```

---

## Dependencies

```text
image-gallery

networking

avd-hostpool
```

---

# 16. FSLogix Storage Module Contract

## Module

```text
modules/fslogix-storage
```

---

## Purpose

Provides FSLogix profile storage.

---

## Supported Storage Types

```text
Azure Files

Azure NetApp Files
```

---

## Inputs

```text
storage_type

resource_group_name

location

tags
```

---

## Outputs

```text
profile_share_name

profile_share_path

storage_account_id
```

---

## Dependencies

```text
resource-group
```

---

# 17. Module Lifecycle

Every module follows:

```text
Design

Document

Review

Implement

Validate

Commit
```

A module is not considered complete until:

```text
Terraform Validate Successful

Terraform Plan Successful

Outputs Verified

Documentation Updated
```

---

# 18. Future Module Expansion

Future modules may include:

```text
scaling-plans

backup

update-manager

defender

policy

cost-management
```

Future modules must follow the same standards defined in this document.

---

# 19. Contract Summary

All platform modules must:

```text
Be Self-Contained

Use Variables For Inputs

Use Outputs For Integration

Avoid Hardcoded Values

Support Tagging

Follow Repository Standards

Follow Naming Standards

Follow Phase-Based Documentation
```

These requirements apply to all current and future Terraform modules.