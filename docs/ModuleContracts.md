# Azure Virtual Desktop Enterprise Platform Module Contracts

# 1. Purpose

This document defines the standards, requirements, responsibilities, inputs, outputs, and dependencies for every Terraform module used within the Azure Virtual Desktop Enterprise Platform.

The purpose of module contracts is to:

- Ensure consistency across all modules
- Prevent tightly-coupled module design
- Improve maintainability
- Improve reusability
- Reduce future refactoring
- Standardize documentation

This document is considered the source of truth for all Terraform module development within this repository.

---

# 2. Terraform Module Standards

Every Terraform module shall contain the following files:

```text
module-name/

├── README.md
├── versions.tf
├── main.tf
├── variables.tf
└── outputs.tf
```

Additional files may be introduced when required.

Example:

```text
session-hosts/

├── README.md
├── versions.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── extensions.tf
```

---

# 3. Module Development Rules

## Rule 1

Modules must be self-contained.

Modules must not depend on internal resources of another module.

Allowed:

```hcl
variable "subnet_id"
```

Not allowed:

```hcl
module.networking.subnet_id
```

inside module code.

---

## Rule 2

Modules communicate only through:

```text
Variables

Outputs
```

---

## Rule 3

All reusable resource identifiers must be exported.

Examples:

```hcl
output "resource_group_id"

output "host_pool_id"

output "workspace_id"
```

---

## Rule 4

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

## Rule 5

All resources must support tagging.

Every module must accept:

```hcl
variable "tags"
```

---

## Rule 6

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

## Rule 7

Comments must be professional.

Allowed:

```hcl
# Create Azure Virtual Desktop Host Pool
```

Not allowed:

```hcl
# Magic stuff happens here
```

---

## Rule 8

All Terraform files use section headers.

Example:

```hcl
# =============================================================================
# LOCAL VALUES
# =============================================================================

# =============================================================================
# RESOURCE GROUP
# =============================================================================

# =============================================================================
# OUTPUTS
# =============================================================================
```

---

# 4. Global Module Inputs

Most modules will consume:

```hcl
prefix

environment

location

resource_group_name

tags
```

These variables should remain consistent across the platform.

---

# 5. Root Module Responsibilities

The root module is responsible for:

```text
Module orchestration

Dependency handling

Environment configuration

Variable assignment
```

Modules are responsible only for their specific workload.

---

# 6. Module Contract - Resource Group

## Module

```text
modules/resource-group
```

---

## Purpose

Creates resource groups for platform resources.

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

# 7. Module Contract - Networking

## Module

```text
modules/networking
```

---

## Purpose

Deploys networking resources.

---

## Resources

```text
Virtual Network

Subnets

Network Security Group

Route Table (optional)
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

# 8. Module Contract - Identity

## Module

```text
modules/identity
```

---

## Purpose

Manages Azure AD groups and RBAC assignments.

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

# 9. Module Contract - Image Gallery

## Module

```text
modules/image-gallery
```

---

## Purpose

Creates Azure Compute Gallery components.

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

# 10. Module Contract - Monitoring

## Module

```text
modules/monitoring
```

---

## Purpose

Provides monitoring infrastructure for Azure Virtual Desktop.

---

## Resources

```text
Log Analytics Workspace

Data Collection Rules

Diagnostic Settings

Workbook

Action Groups

Alerts
```

---

## Inputs

```text
host_pool_id

workspace_id

application_group_id

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

networking
```

---

# 11. Module Contract - AVD Workspace

## Module

```text
modules/avd-workspace
```

---

## Purpose

Creates Azure Virtual Desktop workspace.

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

# 12. Module Contract - AVD Host Pool

## Module

```text
modules/avd-hostpool
```

---

## Purpose

Creates Azure Virtual Desktop host pool.

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

# 13. Module Contract - AVD Application Group

## Module

```text
modules/avd-appgroup
```

---

## Purpose

Creates application groups.

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

# 14. Module Contract - Session Hosts

## Module

```text
modules/session-hosts
```

---

## Purpose

Deploys Azure Virtual Desktop session hosts from Azure Compute Gallery images.

Marketplace deployments are prohibited.

---

## Resources

```text
Network Interfaces

Virtual Machines

Managed Disks

Host Pool Registration
```

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

# 15. Module Contract - FSLogix Storage

## Module

```text
modules/fslogix-storage
```

---

## Purpose

Provides profile storage for FSLogix containers.

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

# 16. Documentation Requirements

Every module README must contain:

## Purpose

Describe what the module creates.

---

## Resources

List all deployed resources.

---

## Inputs

Document every variable.

---

## Outputs

Document every output.

---

## Dependencies

List required modules.

---

## Example Usage

Provide working Terraform example.

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

- Terraform Validate succeeds
- Terraform Plan succeeds
- Outputs are verified
- README is completed

---

# 18. Future Module Expansion

The following modules may be added later:

```text
scaling-plans

backup

update-manager

defender

policy

cost-management
```

These future modules must follow the same standards defined in this document.

---

# 19. Contract Summary

All platform modules must:

- Be self-contained
- Use variables for inputs
- Use outputs for integration
- Never contain hardcoded values
- Always support tagging
- Always include documentation
- Follow repository naming standards
- Support enterprise-scale deployment patterns

This contract applies to all current and future modules within the Azure Virtual Desktop Enterprise Platform repository.