# Phase 5 - Core Infrastructure Foundation

# 1. Purpose

Phase 5 introduces the foundational Azure networking infrastructure required by all future Azure Virtual Desktop platform components.

The purpose of this phase is to establish a secure, repeatable, and environment-specific network foundation that will be consumed by future platform services.

Phase 5 creates the networking layer required by:

```text
Identity

Azure Virtual Desktop

Monitoring

Session Hosts

FSLogix Storage
```

No workloads are deployed during this phase.

Phase 5 establishes only the infrastructure foundation upon which future phases depend.

---

# 2. Scope

The following items are implemented during Phase 5:

```text
Resource Groups

Virtual Networks

Subnets

Network Security Groups

Network Security Group Associations

Terraform Resource Group Module

Terraform Networking Module
```

The following items are not implemented during Phase 5:

```text
Azure AD Groups

RBAC Assignments

Log Analytics Workspaces

Azure Monitor Agent

Data Collection Rules

Azure Virtual Desktop Resources

Session Hosts

FSLogix Storage

Route Tables

Azure Firewall

VPN Gateway

ExpressRoute
```

These components are delivered in later phases.

---

# 3. Repository Structure

Phase 5 introduces the first networking modules.

```text
Azure_Virtual_Desktop/
│
├── modules/
│   ├── resource-group/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── networking/
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

# 4. Root Module Design

The root Terraform module orchestrates the Phase 5 infrastructure deployment.

The root module is responsible for:

```text
Environment Selection

Environment Variable Assignment

Module Orchestration

Dependency Management

Common Naming Values

Output Exposure
```

The root module does not directly create Azure resource groups or networking resources.

Azure resources are created only through their respective Terraform modules:

```text
modules/resource-group

modules/networking
```

This ensures that resource creation remains modular, reusable, and aligned with the standards defined in:

```text
Phase-0_ModuleContracts.md
```

---

## Root Module Components

The Phase 5 root module consists of:

```text
main.tf

locals.tf

variables.tf

outputs.tf
```

Each file has a clearly defined responsibility.

---

## main.tf

The root `main.tf` file is responsible for:

```text
Calling The Resource Group Module

Calling The Networking Module

Passing Root Variables To Modules

Passing Module Outputs Between Modules

Managing Module Dependencies
```

The Resource Group module is called before the Networking module.

The Networking module receives the resource group name and location through outputs exposed by the Resource Group module.

The dependency flow is:

```text
Root Module

      │

      ▼

Resource Group Module

      │

      ├── resource_group_name

      └── resource_group_location

      │

      ▼

Networking Module
```

The root module may reference module outputs when passing values between modules.

Terraform modules must not directly reference resources or outputs from other modules within their own implementation.

---

## locals.tf

The root `locals.tf` file is responsible for defining reusable values required for naming and orchestration.

The local values include:

```text
Platform Prefix

Workload Identifier

Normalized Environment

Common Naming Components
```

Example:

```hcl
locals {
  prefix      = "AK"
  workload    = "AVD"
  environment = upper(var.environment)
}
```

Environment-specific CIDR values must not be defined in `locals.tf`.

CIDR values are supplied through:

```text
environments/dev.tfvars

environments/test.tfvars

environments/prod.tfvars
```

---

## variables.tf

The root `variables.tf` file defines the inputs required to deploy Phase 5 resources.

Required root variables include:

```text
environment

location

vnet_address_space

subnet_definitions

tags
```

The environment-specific Terraform variable files provide values for these variables.

The root module passes the required values to the Resource Group and Networking modules.

All variables must include:

```text
Description

Type
```

Variable validation should be used where appropriate to reject unsupported configuration values before deployment.

---

## outputs.tf

The root `outputs.tf` file exposes values required for validation and future platform phases.

Required root outputs include:

```text
resource_group_id

resource_group_name

resource_group_location

vnet_id

vnet_name

subnet_ids

network_security_group_ids
```

The root module exposes these values by referencing the outputs of the Resource Group and Networking modules.

Future phases consume reusable infrastructure values through documented module outputs rather than directly referencing resources created inside another module.

---

## Environment Configuration Flow

The selected environment determines which Terraform variable file is loaded.

```text
DEV

environments/dev.tfvars
```

```text
TEST

environments/test.tfvars
```

```text
PROD

environments/prod.tfvars
```

The environment configuration provides:

```text
Environment

Azure Region

Virtual Network Address Space

Subnet CIDR Definitions

Resource Tags
```

The environment configuration flow is:

```text
Selected Environment

      │

      ▼

Environment tfvars File

      │

      ▼

Root Variables

      │

      ▼

Root Module

      │

      ├── Resource Group Module

      └── Networking Module
```

---

## Module Dependency Flow

The Phase 5 module dependency flow is:

```text
Environment tfvars

      │

      ▼

Root Module

      │

      ▼

Resource Group Module

      │

      ├── Resource Group ID

      ├── Resource Group Name

      └── Resource Group Location

      │

      ▼

Networking Module

      │

      ├── Virtual Network

      ├── Subnets

      ├── Network Security Groups

      └── Network Security Group Associations
```

The Networking module depends on the Resource Group module because networking resources require an existing resource group.

This dependency is established by passing the Resource Group module outputs into the Networking module inputs.

No explicit `depends_on` declaration is required when one module directly consumes another module's outputs because Terraform derives the dependency from those references.

---

## Root Module Design Principles

The Phase 5 root module must follow these principles:

```text
No Azure Resources Created Directly In The Root Module

No Hardcoded Environment-Specific CIDRs

No Hardcoded Azure Resource Names

Environment Configuration Supplied Through tfvars

Resource Creation Delegated To Dedicated Modules

Module Communication Through Variables And Outputs

Reusable Values Defined Once

Root Outputs Exposed For Validation And Future Phases
```

This design keeps the root module focused on orchestration while the Resource Group and Networking modules remain responsible for creating and managing their respective Azure resources.

---

# 5. Core Infrastructure Architecture

The platform uses environment-isolated networking.

Each environment receives its own:

```text
Resource Group

Virtual Network

Subnets

Network Security Groups
```

This provides:

```text
Environment Isolation

Independent Growth

Simplified Troubleshooting

Cleaner Security Boundaries

Future Expansion Support
```

---

## Architecture Flow

```text
Resource Group

      │

      ▼

Virtual Network

      │

      ▼

Subnets

      │

      ▼

Network Security Groups

      │

      ▼

Future Platform Components
```

---

# 6. Resource Group Strategy

Each environment receives its own networking resource group.

---

## DEV

```text
AK-AVD-DEV-NET-RG
```

---

## TEST

```text
AK-AVD-TEST-NET-RG
```

---

## PROD

```text
AK-AVD-PROD-NET-RG
```

---

## Purpose

The networking resource group stores:

```text
Virtual Networks

Subnets

Network Security Groups

Future Route Tables

Future Networking Components
```

---

# 7. Virtual Network Strategy

Each environment receives a dedicated virtual network.

---

## DEV

```text
AK-AVD-DEV-VNET
```

---

## TEST

```text
AK-AVD-TEST-VNET
```

---

## PROD

```text
AK-AVD-PROD-VNET
```

---

## Design Principles

```text
One VNET Per Environment

No Shared VNETs

No Cross-Environment Dependencies

Environment Isolation First
```

---

# 8. CIDR Strategy

Network address spaces are environment-specific.

CIDR values must never be hardcoded within Terraform modules.

This aligns with:

```text
Module Contracts

Principle 3 - No Hardcoded Values
```

---

## Environment Configuration

CIDR values are provided through:

```text
environments/dev.tfvars

environments/test.tfvars

environments/prod.tfvars
```

---

## Required Variables

### Virtual Network Address Space

Example:

```hcl
vnet_address_space = [
  "10.10.0.0/16"
]
```

---

### Subnet Definitions

Example:

```hcl
subnet_definitions = {
  sessionhosts = "10.10.1.0/24"
  build        = "10.10.2.0/24"
  management   = "10.10.3.0/24"
}
```
### Recommended Environment Allocation

```text
DEV
10.10.0.0/16

TEST
10.20.0.0/16

PROD
10.30.0.0/16

Note:

These values are recommended standards.
Terraform modules do not contain hardcoded CIDRs.
Actual values are provided through environment tfvars files.
```

---

## Design Principles

```text
No Hardcoded CIDRs

Environment-Specific Configuration

Reusable Networking Module

Future Expansion Support

```

---

# 9. Subnet Strategy

Each environment receives three dedicated subnets.

---

## Session Hosts Subnet

Pattern:

```text
AK-AVD-<ENV>-SNET-SESSIONHOSTS
```

Examples:

```text
AK-AVD-DEV-SNET-SESSIONHOSTS

AK-AVD-TEST-SNET-SESSIONHOSTS

AK-AVD-PROD-SNET-SESSIONHOSTS
```

Purpose:

```text
Future Azure Virtual Desktop Session Hosts
```

---

## Build Subnet

Pattern:

```text
AK-AVD-<ENV>-SNET-BUILD
```

Examples:

```text
AK-AVD-DEV-SNET-BUILD

AK-AVD-TEST-SNET-BUILD

AK-AVD-PROD-SNET-BUILD
```

Purpose:

```text
Future Packer Build Virtual Machines
```

---

## Management Subnet

Pattern:

```text
AK-AVD-<ENV>-SNET-MANAGEMENT
```

Examples:

```text
AK-AVD-DEV-SNET-MANAGEMENT

AK-AVD-TEST-SNET-MANAGEMENT

AK-AVD-PROD-SNET-MANAGEMENT
```

Purpose:

```text
Future Administrative Resources

Automation Components

Management Services

Jump Hosts
```

---

# 10. Network Security Group Strategy

The platform uses one Network Security Group per subnet.

This approach provides:

```text
Improved Security Isolation

Simplified Rule Management

Independent Security Policies

Enterprise Networking Alignment
```

---

## Session Host NSG

Pattern:

```text
AK-AVD-<ENV>-SH-NSG
```

Examples:

```text
AK-AVD-DEV-SH-NSG

AK-AVD-TEST-SH-NSG

AK-AVD-PROD-SH-NSG
```

Associated Subnet:

```text
AK-AVD-<ENV>-SNET-SESSIONHOSTS
```

---

## Build NSG

Pattern:

```text
AK-AVD-<ENV>-BUILD-NSG
```

Examples:

```text
AK-AVD-DEV-BUILD-NSG

AK-AVD-TEST-BUILD-NSG

AK-AVD-PROD-BUILD-NSG
```

Associated Subnet:

```text
AK-AVD-<ENV>-SNET-BUILD
```

---

## Management NSG

Pattern:

```text
AK-AVD-<ENV>-MGMT-NSG
```

Examples:

```text
AK-AVD-DEV-MGMT-NSG

AK-AVD-TEST-MGMT-NSG

AK-AVD-PROD-MGMT-NSG
```

Associated Subnet:

```text
AK-AVD-<ENV>-SNET-MANAGEMENT
```

---

## Security Model

Phase 5 creates the Network Security Groups and associates them with their respective subnets.

No custom Network Security Group rules are deployed during this phase.

Only Azure default security rules are present.

Custom security policies will be introduced in future phases when workload requirements are known.

---

# 11. Route Table Design

Route tables are not deployed during Phase 5.

---

## Future Route Table Pattern

```text
AK-AVD-<ENV>-RT
```

Examples:

```text
AK-AVD-DEV-RT

AK-AVD-TEST-RT

AK-AVD-PROD-RT
```

---

## Future Use Cases

```text
Azure Firewall Integration

User Defined Routes

Hub And Spoke Networking

Hybrid Connectivity

Enterprise Network Segmentation
```

---

# 12. Resource Group Module

## Module

```text
modules/resource-group
```

---

## Purpose

Creates environment-specific networking resource groups.

---

## Inputs

```text
prefix

environment

workload_code

location

tags
```

## Supported Workload Codes

```text
NET = Networking
IMG = Image Infrastructure
ID  = Identity
AVD = Azure Virtual Desktop
MON = Monitoring
FSL = FSLogix Storage
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

# 13. Networking Module

## Module

```text
modules/networking
```

---

## Purpose

Creates networking resources consumed by future platform components.

---

## Resources

```text
Virtual Network

Subnets

Network Security Groups

Network Security Group Associations
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

network_security_group_ids
```

---

## Dependencies

```text
modules/resource-group
```

---

# 14. Terraform Variable Requirements

The networking module requires environment-specific configuration.

---

## Required Variables

### Virtual Network Address Space

```hcl
variable "vnet_address_space"
```

Purpose:

```text
Defines the virtual network CIDR range.
```

---

### Subnet Definitions

```hcl
variable "subnet_definitions"
```

Purpose:

```text
Defines subnet CIDR ranges.
```

---

### Tags

```hcl
variable "tags"
```

Purpose:

```text
Applies platform-standard tags to all resources.
```

---

# 15. Deployment Flow

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

Resource Group Module

      │

      ▼

Networking Module

      │

      ▼

Resource Group

      │

      ▼

Virtual Network

      │

      ▼

Subnets

      │

      ▼

Network Security Groups

      │

      ▼

Subnet Associations
```

---

# 16. Validation Checklist

Verify:

```text
Resource Group Created

Virtual Network Created

Session Hosts Subnet Created

Build Subnet Created

Management Subnet Created

Session Host NSG Created

Build NSG Created

Management NSG Created

NSGs Associated With Subnets

Terraform Validate Successful

Terraform Plan Successful

Terraform Apply Successful
```

---

# 17. Exit Criteria

Phase 5 is complete when:

```text
Resource Group Module Implemented

Networking Module Implemented

Virtual Network Created

Session Hosts Subnet Created

Build Subnet Created

Management Subnet Created

Session Host NSG Created

Build NSG Created

Management NSG Created

Network Security Groups Associated

Environment-Specific CIDR Strategy Implemented

Terraform Validate Successful

Terraform Plan Successful

Platform Networking Foundation Operational
```

The platform is now ready for:

```text
Phase 6 - Identity And Access Control
```

---

# 18. Next Phase

Upon completion of Phase 5 the project moves to:

```text
Phase 6 - Identity And Access Control
```

Phase 6 introduces:

```text
Azure AD Groups

Group-Based Access Control

RBAC Assignments

Identity Terraform Module
```

No Azure Virtual Desktop workloads are deployed during Phase 6.

The focus remains on identity and authorization foundations before AVD resources are introduced.