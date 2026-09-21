# Phase 9 - Session Hosts

# 1. Purpose

Phase 9 introduces Azure Virtual Desktop Session Hosts.

This is the first phase that deploys user-facing compute resources into the Azure Virtual Desktop platform.

Session Hosts are deployed from Golden Images stored in Azure Compute Gallery and registered with the Azure Virtual Desktop Host Pools created during Phase 7.

Session Hosts are Microsoft Entra ID joined.

Monitoring is enabled using the Azure Monitor Agent VM Extension and Data Collection Rule Associations from the monitoring foundation created during Phase 8.

All Session Host configuration is environment-driven and controlled through tfvars files.

No Session Host deployment configuration is hardcoded within Terraform modules.

---

# 2. Scope

The following items are implemented during Phase 9:

```text
Session Host Virtual Machines

Network Interfaces

Azure Compute Gallery Image Consumption

Microsoft Entra ID Join

Azure Virtual Desktop Host Pool Registration

Host Pool Registration Tokens

Azure Monitor Agent VM Extension

Data Collection Rule Associations

Session Host Count

VM Size

OS Disk Configuration

Subnet Selection

Multi Host Pool Session Host Deployment

Environment Driven Session Host Configuration

Object Driven Session Host Configuration
```

The following items are not implemented during Phase 9:

```text
FSLogix Storage Infrastructure

Azure Files

Azure NetApp Files

Scaling Plans

Application Installation

Golden Image Customization

Backup

Azure Update Manager

Microsoft Intune Configuration

Conditional Access

PIM

Advanced Security Controls
```

These capabilities are implemented during future phases where required.

---

# 3. Phase Dependencies

Phase 9 consumes infrastructure created during previous phases.

---

## Phase 3 And Phase 4

```text
Azure Compute Gallery

Image Definition

Golden Image Version
```

---

## Phase 5

```text
Virtual Network

Session Hosts Subnet

Network Security Group
```

---

## Phase 6

```text
Microsoft Entra ID Groups
```

---

## Phase 7

```text
Azure Virtual Desktop Workspace

Azure Virtual Desktop Host Pools

Azure Virtual Desktop Application Groups
```

---

## Phase 8

```text
Log Analytics Workspace

Data Collection Rules

Monitoring Configuration
```

---

# 4. Repository Structure

Phase 9 introduces the Session Hosts module.

```text
Azure_Virtual_Desktop/
│
├── modules/
│   └── session-hosts/
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

# 5. Session Host Architecture

Session Hosts connect the platform foundations created during previous phases.

The deployment flow is:

```text
Azure Compute Gallery

        │

        ▼

Golden Image

        │

        ▼

Session Host VM

        │

        ├──────────────► Network Interface
        │
        │                     │
        │                     ▼
        │
        │              Session Hosts Subnet
        │
        ▼

Microsoft Entra ID Join

        │

        ▼

AVD Host Pool Registration

        │

        ▼

Azure Monitor Agent

        │

        ▼

Data Collection Rule Associations

        │

        ▼

Operational Session Host
```

---

# 6. Session Host Resource Strategy

Session Hosts are deployed according to the Host Pool definitions created during Phase 7.

Each Host Pool can independently control:

```text
Session Host Deployment

Session Host Count

VM Size

Golden Image Version

Subnet

OS Disk Configuration

Microsoft Entra ID Join

Azure Monitor Agent

Data Collection Rules
```

This allows different Host Pools to run different Session Host configurations while using the same Terraform module.

---

# 7. Session Host Naming Strategy

The original Session Host naming convention is extended to support multiple Host Pools.

---

## Previous Pattern

```text
AK-AVD-<ENV>-SHXX
```

This pattern does not identify the Host Pool when multiple Host Pools exist.

---

## Phase 9 Pattern

```text
AK-AVD-<ENV>-<POOL>-SHXX
```

---

## Examples

```text
AK-AVD-DEV-GENERAL-SH01

AK-AVD-DEV-GENERAL-SH02

AK-AVD-DEV-DEVELOPERS-SH01

AK-AVD-DEV-DEVELOPERS-SH02

AK-AVD-DEV-FINANCE-SH01
```

---

## Design Principle

```text
Environment Identifiable

Host Pool Identifiable

Session Host Identifiable

Consistent Across Multiple Host Pools
```

---

# 8. Network Interface Naming Strategy

Each Session Host receives a dedicated Network Interface.

---

## Naming Pattern

```text
AK-AVD-<ENV>-<POOL>-NICXX
```

---

## Examples

```text
AK-AVD-DEV-GENERAL-NIC01

AK-AVD-DEV-GENERAL-NIC02

AK-AVD-DEV-DEVELOPERS-NIC01

AK-AVD-DEV-FINANCE-NIC01
```

---

# 9. Network Strategy

Session Hosts consume networking infrastructure created during Phase 5.

No Virtual Network or subnet is created by the Session Hosts module.

---

## Default Session Host Subnet

```text
AK-AVD-<ENV>-SNET-SESSIONHOSTS
```

---

## Examples

```text
AK-AVD-DEV-SNET-SESSIONHOSTS

AK-AVD-TEST-SNET-SESSIONHOSTS

AK-AVD-PROD-SNET-SESSIONHOSTS
```

---

## Subnet Selection

Subnet selection is controlled through tfvars.

Example:

```hcl
network = {
  subnet_key = "sessionhosts"
}
```

The Session Hosts module consumes the subnet ID exposed by the networking foundation.

Subnet IDs must not be hardcoded.

---

# 10. Golden Image Strategy

All Session Hosts must be deployed from Azure Compute Gallery.

Marketplace images must not be directly consumed by Session Host deployments.

This maintains:

```text
Golden Image Consistency

Predictable Configuration

Image Version Control

Repeatable Deployments
```

---

## Image Definition

Current Image Definition:

```text
AK-WIN11-MS
```

---

## Image Selection

Image selection is controlled through tfvars.

Example:

```hcl
image = {
  definition = "AK-WIN11-MS"
  version    = "1.0.0"
}
```

---

## Image Version Strategy

Different environments or Host Pools may consume different image versions.

Example:

```text
GENERAL

1.0.0
```

```text
DEVELOPERS

1.1.0
```

```text
FINANCE

1.0.1
```

This enables controlled image rollout without modifying Terraform module code.

---

# 11. Microsoft Entra ID Join Strategy

Session Hosts are Microsoft Entra ID joined.

The selected Phase 9 Join Type is:

```text
Microsoft Entra ID
```

---

## tfvars Representation

```hcl
join_type = "EntraID"
```

The join type remains parameterized instead of being hardcoded within the Session Hosts module.

---

## Design Principles

```text
Cloud Native Identity

No Active Directory Domain Controller Dependency

Environment Driven Configuration

Consistent Identity Model Per Host Pool
```

---

## Host Pool Identity Consistency

All Session Hosts belonging to the same Host Pool must use the same identity join strategy.

The platform must not intentionally deploy mixed identity join types within the same Host Pool.

---

# 12. Host Pool Registration Strategy

Every Session Host must register with its corresponding Azure Virtual Desktop Host Pool.

Host Pool registration is managed automatically during deployment.

---

## Registration Flow

```text
Host Pool

    │

    ▼

Registration Information

    │

    ▼

Temporary Registration Token

    │

    ▼

Session Host

    │

    ▼

AVD Registration

    │

    ▼

Host Pool Membership
```

---

## Multi Host Pool Registration

Each Session Host configuration uses the corresponding Host Pool map key.

Example:

```text
general
```

maps to:

```text
AK-AVD-DEV-HP-GENERAL
```

and therefore:

```text
AK-AVD-DEV-GENERAL-SH01
AK-AVD-DEV-GENERAL-SH02
```

register only with:

```text
AK-AVD-DEV-HP-GENERAL
```

---

## Registration Principle

```text
One Session Host

One Host Pool

Correct Host Pool Mapping

No Hardcoded Registration Tokens
```

Registration tokens are generated during deployment and must not be stored inside tfvars files.

---

# 13. Session Host Object Design

The `host_pools` object introduced during Phase 7 is extended during Phase 9.

This keeps Host Pool and Session Host configuration within the same logical deployment contract.

---

## Complete Example

```hcl
host_pools = {
  general = {
    host_pool_name         = "GENERAL"
    host_pool_type         = "Pooled"
    application_group_type = "Desktop"
    load_balancer_type     = "BreadthFirst"

    session_hosts = {
      enabled = true

      count   = 2
      vm_size = "Standard_D4s_v5"

      join_type = "EntraID"

      image = {
        definition = "AK-WIN11-MS"
        version    = "1.0.0"
      }

      network = {
        subnet_key = "sessionhosts"
      }

      os_disk = {
        storage_account_type = "Premium_LRS"
        disk_size_gb         = 128
        caching              = "ReadWrite"
      }

      monitoring = {
        ama_enabled = true

        dcr_keys = [
          "sessionhosts",
          "fslogix"
        ]
      }
    }
  }

  developers = {
    host_pool_name         = "DEVELOPERS"
    host_pool_type         = "Personal"
    application_group_type = "Desktop"
    load_balancer_type     = null

    session_hosts = {
      enabled = true

      count   = 2
      vm_size = "Standard_D8s_v5"

      join_type = "EntraID"

      image = {
        definition = "AK-WIN11-MS"
        version    = "1.0.0"
      }

      network = {
        subnet_key = "sessionhosts"
      }

      os_disk = {
        storage_account_type = "Premium_LRS"
        disk_size_gb         = 256
        caching              = "ReadWrite"
      }

      monitoring = {
        ama_enabled = true

        dcr_keys = [
          "sessionhosts"
        ]
      }
    }
  }

  finance = {
    host_pool_name         = "FINANCE"
    host_pool_type         = "Pooled"
    application_group_type = "RemoteApp"
    load_balancer_type     = "DepthFirst"

    session_hosts = {
      enabled = false

      count   = 2
      vm_size = "Standard_D4s_v5"

      join_type = "EntraID"

      image = {
        definition = "AK-WIN11-MS"
        version    = "1.0.0"
      }

      network = {
        subnet_key = "sessionhosts"
      }

      os_disk = {
        storage_account_type = "Premium_LRS"
        disk_size_gb         = 128
        caching              = "ReadWrite"
      }

      monitoring = {
        ama_enabled = true

        dcr_keys = [
          "sessionhosts",
          "fslogix"
        ]
      }
    }
  }
}
```

---

# 14. Session Host Enablement

Session Host deployment can be enabled or disabled independently for each Host Pool.

---

## Enabled

```hcl
session_hosts = {
  enabled = true
}
```

Terraform deploys Session Hosts for that Host Pool.

---

## Disabled

```hcl
session_hosts = {
  enabled = false
}
```

Terraform does not deploy Session Hosts for that Host Pool.

The Host Pool and Application Group remain available as control plane resources.

---

# 15. Session Host Count

Session Host count is controlled independently for each Host Pool.

Example:

```hcl
count = 2
```

Another Host Pool may use:

```hcl
count = 5
```

The same Terraform module handles both configurations.

---

## Design Principle

```text
No Hardcoded VM Counts

Host Pool Specific Capacity

Environment Driven Capacity
```

---

# 16. VM Size Strategy

VM size is controlled through tfvars.

Example:

```hcl
vm_size = "Standard_D4s_v5"
```

Another Host Pool may use:

```hcl
vm_size = "Standard_D8s_v5"
```

This enables different Host Pools to support different workload requirements.

---

# 17. OS Disk Strategy

OS Disk configuration is controlled through the Session Host object.

---

## Example

```hcl
os_disk = {
  storage_account_type = "Premium_LRS"
  disk_size_gb         = 128
  caching              = "ReadWrite"
}
```

---

## Properties

```text
storage_account_type

disk_size_gb

caching
```

No OS Disk configuration is hardcoded within the Session Hosts module.

---

# 18. Azure Monitor Agent Strategy

Azure Monitor Agent is deployed as a VM Extension.

Azure Monitor Agent is not installed inside the Golden Image.

This preserves separation between:

```text
Image Configuration

Runtime Monitoring Configuration
```

---

## Enable AMA

```hcl
monitoring = {
  ama_enabled = true
}
```

---

## Disable AMA

```hcl
monitoring = {
  ama_enabled = false
}
```

AMA deployment can therefore be controlled independently for each Host Pool.

---

# 19. Data Collection Rule Association Strategy

Data Collection Rules are created during Phase 8.

Phase 9 associates Session Hosts with the required Data Collection Rules.

A Session Host may be associated with multiple applicable DCRs.

---

## Example

```hcl
monitoring = {
  ama_enabled = true

  dcr_keys = [
    "sessionhosts",
    "fslogix"
  ]
}
```

The keys reference DCRs configured within the Phase 8 monitoring object.

---

## Example Mapping

```text
sessionhosts

      │

      ▼

AK-AVD-DEV-DCR-SESSIONHOSTS
```

and:

```text
fslogix

      │

      ▼

AK-AVD-DEV-DCR-FSLOGIX
```

---

## Design Principle

```text
No Hardcoded DCR IDs

DCR Selection Through tfvars

Multiple DCR Associations Supported

Host Pool Specific Monitoring
```

---

# 20. Monitoring Flow

```text
Session Host VM

      │

      ▼

Azure Monitor Agent

      │

      ▼

DCR Associations

      │

      ├──────────────► Session Host DCR
      │
      ├──────────────► FSLogix DCR
      │
      └──────────────► Future DCRs
                        │
                        ▼

                Log Analytics Workspace
```

---

# 21. Session Hosts Terraform Module

## Module

```text
modules/session-hosts
```

---

## Purpose

Creates Session Host infrastructure and integrates Session Hosts with the Azure Virtual Desktop and monitoring platforms.

---

## Resources

```text
Network Interfaces

Windows Virtual Machines

Microsoft Entra ID Join Configuration

Host Pool Registration

Azure Monitor Agent VM Extensions

Data Collection Rule Associations
```

---

## Inputs

```text
resource_group_name

location

environment

host_pool_key

host_pool_id

host_pool_name

session_hosts

subnet_id

image_id

dcr_ids

tags
```

---

## Outputs

```text
session_host_ids

session_host_names

network_interface_ids

network_interface_names
```

---

# 22. Terraform Iteration Strategy

Phase 7 introduced multiple Host Pools.

Phase 9 extends this model so Session Hosts can be independently created for each Host Pool.

The root Terraform configuration iterates over enabled Session Host definitions.

Conceptually:

```text
host_pools

      │

      ▼

Enabled Session Host Configurations

      │

      ▼

Session Hosts Module

      │

      ▼

N Session Hosts Per Host Pool
```

---

## Conceptual Root Module

```hcl
module "session_hosts" {
  for_each = {
    for key, value in var.host_pools :
    key => value
    if value.session_hosts.enabled
  }

  source = "./modules/session-hosts"

  environment = var.environment
  location    = var.location

  host_pool_key  = each.key
  host_pool_id   = module.avd_hostpool[each.key].host_pool_id
  host_pool_name = module.avd_hostpool[each.key].host_pool_name

  session_hosts = each.value.session_hosts

  subnet_id = module.networking.subnet_ids[
    each.value.session_hosts.network.subnet_key
  ]

  tags = local.common_tags
}
```

The final implementation must continue following the platform Module Contract principles.

---

# 23. Multi Host Pool Deployment Example

The platform can deploy different Session Host configurations simultaneously.

Example:

```text
GENERAL

Host Pool Type:
Pooled

Application Group:
Desktop

Session Hosts:
2

VM Size:
Standard_D4s_v5

Image:
1.0.0

Monitoring:
AMA Enabled
SessionHosts DCR
FSLogix DCR
```

---

```text
DEVELOPERS

Host Pool Type:
Personal

Application Group:
Desktop

Session Hosts:
2

VM Size:
Standard_D8s_v5

Image:
1.0.0

Monitoring:
AMA Enabled
SessionHosts DCR
```

---

```text
FINANCE

Host Pool Type:
Pooled

Application Group:
RemoteApp

Session Hosts:
Disabled
```

All three configurations use the same Terraform code.

Only tfvars configuration changes.

---

# 24. Session Host Deployment Flow

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

Read Environment tfvars

      │

      ▼

Evaluate Host Pools

      │

      ▼

Filter Enabled Session Host Configurations

      │

      ▼

Resolve Golden Image

      │

      ▼

Resolve Session Host Subnet

      │

      ▼

Create Network Interfaces

      │

      ▼

Create Session Host VMs

      │

      ▼

Microsoft Entra ID Join

      │

      ▼

Generate Host Pool Registration Information

      │

      ▼

Register Session Hosts

      │

      ▼

Deploy Azure Monitor Agent

      │

      ▼

Create DCR Associations

      │

      ▼

Operational AVD Session Hosts
```

---

# 25. Security Principles

Session Host deployment follows the following security principles:

```text
No Client Secrets

No Hardcoded Passwords

No Hardcoded Registration Tokens

OIDC Authentication For Terraform

Microsoft Entra ID Joined Session Hosts

Subnet Level NSG Protection

Golden Image Based Deployment

Runtime Monitoring Through AMA
```

Sensitive deployment values must not be stored within:

```text
Terraform Source Code

tfvars Files

GitHub Repository

Golden Image
```

---

# 26. Validation Requirements

The Session Host object should validate the following requirements:

```text
Session Host Count Must Be Valid

VM Size Must Not Be Empty

Join Type Must Be Supported

Image Definition Must Not Be Empty

Image Version Must Not Be Empty

Subnet Key Must Exist

OS Disk Size Must Be Valid

AMA Enablement Must Be Boolean

Referenced DCR Keys Must Exist
```

---

## Host Pool Validation

The platform must also ensure:

```text
Session Hosts Reference Existing Host Pools

Session Hosts Use Correct Host Pool Mapping

All Session Hosts Within A Host Pool Use Consistent Join Type
```

---

# 27. Validation Checklist

Verify:

```text
Terraform Validate Successful

Terraform Plan Successful

Terraform Apply Successful

Session Host Network Interfaces Created

Session Host Virtual Machines Created

Golden Image Used

Microsoft Entra ID Join Successful

Session Hosts Registered With Correct Host Pool

Session Hosts Visible In Azure Virtual Desktop

Azure Monitor Agent Extension Deployed Where Enabled

DCR Associations Created Where Configured

Session Host Names Correct

Network Interface Names Correct

Subnet Assignment Correct

Outputs Verified
```

---

# 28. Exit Criteria

Phase 9 is complete when:

```text
Session Hosts Module Implemented

Multiple Host Pools Can Deploy Session Hosts

Session Host Deployment Can Be Enabled Per Host Pool

Session Host Count Is tfvars Driven

VM Size Is tfvars Driven

Golden Image Selection Is tfvars Driven

Image Version Is tfvars Driven

Subnet Selection Is tfvars Driven

OS Disk Configuration Is tfvars Driven

Microsoft Entra ID Join Operational

Host Pool Registration Operational

Azure Monitor Agent Deployment Operational

Multiple DCR Associations Supported

No Hardcoded Deployment Values

Session Hosts Visible And Healthy In AVD

Terraform Outputs Verified
```

At the completion of Phase 9 the Azure Virtual Desktop platform contains operational compute resources capable of servicing future user workloads.

---

# 29. Future Session Host Object Expansion

The Session Host object is intentionally designed for future expansion.

Potential future properties may include:

```text
Availability Zones

Accelerated Networking

Boot Diagnostics

Trusted Launch

Secure Boot

vTPM

Encryption At Host

Intune Enrollment

Scaling Configuration

Maintenance Configuration

Update Management

Backup Configuration
```

These capabilities are not required during Phase 9.

They can be introduced without redesigning the core Session Host object model.

---

# 30. Next Phase

Upon completion of Phase 9 the project moves to:

```text
Phase 10 - FSLogix Storage
```

Phase 10 introduces:

```text
FSLogix Profile Storage

Azure Files Or Supported Profile Storage

Storage Account

File Share

Microsoft Entra Kerberos Integration

Profile Access Configuration

Session Host FSLogix Runtime Configuration
```

FSLogix is already installed within the Golden Image.

Phase 10 provides the storage infrastructure required for persistent user profiles.

The Session Hosts deployed during Phase 9 will then consume the FSLogix storage platform.