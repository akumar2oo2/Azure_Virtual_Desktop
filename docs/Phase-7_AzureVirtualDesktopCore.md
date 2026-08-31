# Phase 7 - Azure Virtual Desktop Core

# 1. Purpose

Phase 7 introduces the Azure Virtual Desktop control plane.

The purpose of this phase is to establish the Azure Virtual Desktop foundation that will be consumed by future Session Host deployments.

Phase 7 focuses on Azure Virtual Desktop platform resources only.

No Session Hosts are deployed during this phase.

No user assignments are performed during this phase.

No application publishing is performed during this phase.

All deployment behavior is controlled through environment-specific tfvars files.

---

# 2. Scope

The following items are implemented during Phase 7:

```text
Azure Virtual Desktop Resource Group

Azure Virtual Desktop Workspace

Azure Virtual Desktop Host Pools

Azure Virtual Desktop Application Groups

Workspace Registration

Terraform Azure Virtual Desktop Modules

Environment Driven Deployment Design
```

The following items are not implemented during Phase 7:

```text
Session Hosts

FSLogix Storage

Monitoring

Log Analytics

Azure Monitor Agent

Data Collection Rules

Group Assignments

Role Assignments

Application Publishing

Scaling Plans
```

These components are delivered during future phases.

---

# 3. Repository Structure

Phase 7 introduces Azure Virtual Desktop modules.

```text
Azure_Virtual_Desktop/
│
├── modules/
│   ├── avd-workspace/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── avd-hostpool/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── avd-appgroup/
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

# 4. Azure Virtual Desktop Architecture

The platform deploys Azure Virtual Desktop using a modular architecture.

The Azure Virtual Desktop control plane consists of:

```text
Workspace

Host Pools

Application Groups
```

The platform supports multiple Host Pools and multiple Application Groups within a single environment.

All deployment decisions are controlled through tfvars files.

---

## Architecture Flow

```text
Workspace

      │

      ▼

Application Groups

      │

      ▼

Host Pools

      │

      ▼

Future Session Hosts
```

---

# 5. Azure Virtual Desktop Resource Group Strategy

Each environment receives a dedicated Azure Virtual Desktop Resource Group.

---

## Naming Pattern

```text
AK-AVD-<ENV>-AVD-RG
```

---

## Examples

```text
AK-AVD-DEV-AVD-RG

AK-AVD-TEST-AVD-RG

AK-AVD-PROD-AVD-RG
```

---

## Purpose

The Azure Virtual Desktop Resource Group stores:

```text
Workspace

Host Pools

Application Groups

Future Azure Virtual Desktop Resources
```

---

# 6. Workspace Strategy

Each environment deploys a single Azure Virtual Desktop Workspace.

---

## Naming Pattern

```text
AK-AVD-<ENV>-WS
```

---

## Examples

```text
AK-AVD-DEV-WS

AK-AVD-TEST-WS

AK-AVD-PROD-WS
```

---

## Design Principles

```text
Single Workspace Per Environment

Environment Isolation

Centralized User Access Point

Simple Administration
```

---

# 7. Host Pool Strategy

Host Pools are deployed through environment configuration.

Host Pool types must not be hardcoded within Terraform modules.

The platform supports multiple Host Pools per environment.

---

## Supported Host Pool Types

### Pooled

Purpose:

```text
Multiple Users Share Session Hosts

Non-Persistent User Experience

Lower Infrastructure Cost

Most Common Enterprise Deployment Model
```

---

### Personal

Purpose:

```text
Dedicated Session Host Per User

Persistent User Experience

Specialized Workloads
```

---

## Host Pool Naming Pattern

```text
AK-AVD-<ENV>-HP-<NAME>
```

---

## Examples

```text
AK-AVD-DEV-HP-GENERAL

AK-AVD-DEV-HP-DEVELOPERS

AK-AVD-DEV-HP-FINANCE

AK-AVD-DEV-HP-ENGINEERING
```

---

# 8. Application Group Strategy

Application Groups are environment driven.

Application Group deployment must not be hardcoded inside Terraform modules.

Application Groups are associated with Host Pools and registered to the Workspace.

---

## Supported Application Group Types

### Desktop Application Group

Purpose:

```text
Publish Full Desktop Experience
```

Naming Pattern:

```text
AK-AVD-<ENV>-DAG-<NAME>
```

Examples:

```text
AK-AVD-DEV-DAG-GENERAL

AK-AVD-DEV-DAG-DEVELOPERS
```

---

### Remote Application Group

Purpose:

```text
Publish Individual Applications
```

Naming Pattern:

```text
AK-AVD-<ENV>-RAG-<NAME>
```

Examples:

```text
AK-AVD-DEV-RAG-FINANCE

AK-AVD-DEV-RAG-ENGINEERING
```

---

# 9. Multi Host Pool Design

The platform supports deployment of multiple Host Pools within each environment.

Host Pools are defined through environment-specific tfvars files.

This design allows multiple combinations of Host Pool types, Application Group types, and load-balancing configurations to be deployed using the same Terraform modules.

No Host Pool topology is hardcoded within the Terraform code.

---

## Design Principles

```text
Multiple Host Pools Per Environment

Multiple Application Groups Per Environment

Pooled And Personal Host Pools Supported

Desktop And RemoteApp Application Groups Supported

Environment-Driven Configuration

No Terraform Code Changes Required

Reusable Terraform Modules
```

---

## Example Configuration

The following example deploys:

```text
One Pooled Desktop Host Pool

One Personal Desktop Host Pool

One Pooled RemoteApp Host Pool

One Personal RemoteApp Host Pool
```

```hcl
host_pools = {
  general = {
    host_pool_name         = "GENERAL"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "BreadthFirst"
  }

  developers = {
    host_pool_name         = "DEVELOPERS"
    host_pool_type         = "Personal"
    application_group_type = "Desktop"
    load_balancer_type     = null
  }

  finance = {
    host_pool_name         = "FINANCE"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "DepthFirst"
  }

  engineering = {
    host_pool_name         = "ENGINEERING"
    host_pool_type         = "Personal"
    application_group_type = "RemoteApp"
    load_balancer_type     = null
  }
}
```

---

## Multiple Combination Example

The following example demonstrates how the same Terraform code can deploy:

```text
Two Pooled Desktop Host Pools

Two Personal Desktop Host Pools

Three Pooled RemoteApp Host Pools

One Personal RemoteApp Host Pool
```

```hcl
host_pools = {
  pooled-desktop-01 = {
    host_pool_name         = "POOLED-DESKTOP-01"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "BreadthFirst"
  }

  pooled-desktop-02 = {
    host_pool_name         = "POOLED-DESKTOP-02"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "DepthFirst"
  }

  personal-desktop-01 = {
    host_pool_name         = "PERSONAL-DESKTOP-01"
    host_pool_type         = "Personal"
    application_group_type = "Desktop"
    load_balancer_type     = null
  }

  personal-desktop-02 = {
    host_pool_name         = "PERSONAL-DESKTOP-02"
    host_pool_type         = "Personal"
    application_group_type = "Desktop"
    load_balancer_type     = null
  }

  pooled-remoteapp-01 = {
    host_pool_name         = "POOLED-REMOTEAPP-01"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "BreadthFirst"
  }

  pooled-remoteapp-02 = {
    host_pool_name         = "POOLED-REMOTEAPP-02"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "DepthFirst"
  }

  pooled-remoteapp-03 = {
    host_pool_name         = "POOLED-REMOTEAPP-03"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "BreadthFirst"
  }

  personal-remoteapp-01 = {
    host_pool_name         = "PERSONAL-REMOTEAPP-01"
    host_pool_type         = "Personal"
    application_group_type = "RemoteApp"
    load_balancer_type     = null
  }
}
```

---

## Host Pool Object Design

Each Host Pool is defined as an object within the `host_pools` variable.

Required properties:

```text
host_pool_name

host_pool_type

application_group_type

load_balancer_type
```

---

### Host Pool Name

Purpose:

```text
Provides a friendly logical identifier used to generate
the Host Pool and Application Group resource names.
```

Example:

```hcl
host_pool_name = "FINANCE"
```

The Host Pool name is generated using:

```text
AK-AVD-<ENV>-HP-<NAME>
```

Example:

```text
AK-AVD-DEV-HP-FINANCE
```

The Application Group name is generated from the same logical name.

Desktop example:

```text
AK-AVD-DEV-DAG-FINANCE
```

RemoteApp example:

```text
AK-AVD-DEV-RAG-FINANCE
```

---

### Host Pool Type

Allowed values:

```text
Pooled

Personal
```

Pooled example:

```hcl
host_pool_type = "Pooled"
```

Personal example:

```hcl
host_pool_type = "Personal"
```

The value must be supplied through the environment tfvars file.

The Host Pool type must not be hardcoded inside the Host Pool module.

---

### Application Group Type

Allowed values:

```text
Desktop

RemoteApp
```

Desktop example:

```hcl
application_group_type = "Desktop"
```

RemoteApp example:

```hcl
application_group_type = "RemoteApp"
```

The Application Group type determines the naming pattern used by the platform.

Desktop Application Group:

```text
AK-AVD-<ENV>-DAG-<NAME>
```

RemoteApp Application Group:

```text
AK-AVD-<ENV>-RAG-<NAME>
```

---

### Load Balancer Type

Allowed values:

```text
BreadthFirst

DepthFirst

null
```

Purpose:

```text
Controls how user sessions are distributed
across Session Hosts within a Pooled Host Pool.
```

---

#### BreadthFirst

```hcl
load_balancer_type = "BreadthFirst"
```

Purpose:

```text
Distributes user sessions across available Session Hosts.
```

---

#### DepthFirst

```hcl
load_balancer_type = "DepthFirst"
```

Purpose:

```text
Fills available Session Hosts before using additional Session Hosts.
```

---

#### Personal Host Pools

Personal Host Pools do not use Pooled Host Pool load balancing.

Personal Host Pools must use:

```hcl
load_balancer_type = null
```

---

## Supported Combinations

### Pooled Desktop

```hcl
host_pool_type         = "Pooled"
application_group_type = "Desktop"
load_balancer_type     = "BreadthFirst"
```

---

### Personal Desktop

```hcl
host_pool_type         = "Personal"
application_group_type = "Desktop"
load_balancer_type     = null
```

---

### Pooled RemoteApp

```hcl
host_pool_type         = "Pooled"
application_group_type = "RemoteApp"
load_balancer_type     = "DepthFirst"
```

---

### Personal RemoteApp

```hcl
host_pool_type         = "Personal"
application_group_type = "RemoteApp"
load_balancer_type     = null
```

---

## Validation Requirements

The `host_pools` variable must validate the following requirements:

```text
Host Pool Type Must Be Pooled Or Personal

Application Group Type Must Be Desktop Or RemoteApp

Pooled Host Pools Must Use BreadthFirst Or DepthFirst

Personal Host Pools Must Use null For Load Balancer Type

Host Pool Names Must Not Be Empty

Host Pool Map Keys Must Be Unique
```

---

## Terraform Iteration Strategy

The root module uses the `host_pools` map to create multiple Host Pools.

Conceptual example:

```hcl
module "avd_hostpool" {
  for_each = var.host_pools

  source = "./modules/avd-hostpool"

  resource_group_name = module.avd_resource_group.resource_group_name
  location            = var.location

  host_pool_name     = local.host_pool_names[each.key]
  host_pool_type     = each.value.host_pool_type
  load_balancer_type = each.value.load_balancer_type

  tags = local.common_tags
}
```

The Application Group module uses the same map keys to associate each Application Group with the correct Host Pool.

Conceptual example:

```hcl
module "avd_appgroup" {
  for_each = var.host_pools

  source = "./modules/avd-appgroup"

  resource_group_name = module.avd_resource_group.resource_group_name
  location            = var.location

  host_pool_id          = module.avd_hostpool[each.key].host_pool_id
  workspace_id          = module.avd_workspace.workspace_id
  application_group_name = local.application_group_names[each.key]
  application_group_type = each.value.application_group_type

  tags = local.common_tags
}
```

---

## Future Phase 9 Expansion

The `host_pools` object may be extended during Phase 9 to support Session Host deployment.

Future properties may include:

```text
session_host_count

vm_size

image_version

maximum_sessions_allowed

subnet_key
```

Example future structure:

```hcl
host_pools = {
  finance = {
    host_pool_name         = "FINANCE"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "DepthFirst"

    session_host_count     = 3
    vm_size                = "Standard_D4s_v5"
    image_version          = "1.0.0"
    maximum_sessions_allowed = 10
    subnet_key             = "sessionhosts"
  }
}
```

These Phase 9 properties are documented as future requirements and are not implemented during Phase 7.

---

# 10. Environment Strategy

The Azure Virtual Desktop platform is fully environment driven.

All Azure Virtual Desktop deployment behavior is controlled through tfvars files.

No deployment decisions are hardcoded within Terraform modules.

---

## Single Host Pool Deployment Example

```hcl
host_pools = {
  default = {
    host_pool_name         = "GENERAL"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "BreadthFirst"
  }
}
```

---

## Multiple Host Pool Deployment Example

```hcl
host_pools = {
  general = {
    host_pool_name         = "GENERAL"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "BreadthFirst"
  }

  developers = {
    host_pool_name         = "DEVELOPERS"
    host_pool_type         = "Personal"
    application_group_type = "Desktop"
    load_balancer_type     = null
  }

  finance = {
    host_pool_name         = "FINANCE"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "DepthFirst"
  }
}
```

---

## Design Principle

```text
Terraform Code Does Not Change

Environment Configuration Changes

Platform Behavior Changes
```

This enables:

```text
DEV

TEST

PROD
```

to deploy completely different Azure Virtual Desktop topologies using the same Terraform code.

---

# 11. Workspace Module

## Module

```text
modules/avd-workspace
```

---

## Purpose

Creates Azure Virtual Desktop Workspaces.

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

# 12. Host Pool Module

## Module

```text
modules/avd-hostpool
```

---

## Purpose

Creates Azure Virtual Desktop Host Pools.

Supports both:

```text
Pooled Host Pools

Personal Host Pools
```

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
```

---

# 13. Application Group Module

## Module

```text
modules/avd-appgroup
```

---

## Purpose

Creates Azure Virtual Desktop Application Groups.

Supports:

```text
Desktop Application Groups

Remote Application Groups
```

---

## Inputs

```text
resource_group_name

location

host_pool_id

workspace_id

application_group_name

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

# 14. Future Identity Integration

The Microsoft Entra ID groups introduced during Phase 6 will be consumed by future Azure Virtual Desktop deployments.

Available Groups:

```text
AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk
```

Assignments are intentionally excluded from Phase 7.

Future phases will determine:

```text
Desktop Assignments

RemoteApp Assignments

Administrative Access

Support Access
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

Workspace Module

      │

      ▼

Host Pool Module

      │

      ▼

Application Group Module

      │

      ▼

Workspace Registration

      │

      ▼

Azure Virtual Desktop Control Plane
```

---

# 16. Validation Checklist

Verify:

```text
AVD Resource Group Created

Workspace Created

Host Pools Created

Application Groups Created

Desktop Application Groups Created

Remote Application Groups Created

Application Groups Registered To Workspace

Terraform Validate Successful

Terraform Plan Successful

Terraform Apply Successful

Outputs Verified
```

---

# 17. Exit Criteria

Phase 7 is complete when:

```text
AVD Resource Group Created

Workspace Created

One Or More Host Pools Created

One Or More Application Groups Created

Workspace Registration Successful

Multi Host Pool Design Operational

Pooled Host Pools Supported

Personal Host Pools Supported

Desktop Application Groups Supported

Remote Application Groups Supported

Environment Driven Deployment Working

Outputs Verified
```

The platform now contains a fully operational Azure Virtual Desktop control plane.

No Session Hosts have been deployed yet.

---

# 18. Next Phase

Upon completion of Phase 7 the project moves to:

```text
Phase 8 - Monitoring Platform
```

Phase 8 introduces:

```text
Log Analytics Workspace

Diagnostic Settings

Data Collection Rules

Data Collection Rule Associations

Workbook

Action Groups

Alerts

Azure Monitor Agent VM Extension Strategy
```

Monitoring is implemented before Session Hosts are deployed.

This aligns with:

```text
Architecture Principle 4

Monitoring By Design
```

and ensures observability is available before user workloads are introduced.