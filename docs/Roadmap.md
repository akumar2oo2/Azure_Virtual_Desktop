# Azure Virtual Desktop Enterprise Platform Roadmap

# 1. Project Overview

The purpose of this project is to build a production-ready Azure Virtual Desktop (AVD) platform using modern cloud engineering practices.

The platform will be:

- Terraform driven
- OIDC authenticated
- GitHub Actions managed
- Golden Image based
- Azure Compute Gallery integrated
- FSLogix enabled
- Enterprise monitored
- Multi-environment ready
- Fully documented

The objective is to build a platform that is maintainable, repeatable, secure, and easy to understand from Day 1.

---

# 2. Project Goals

## Primary Goals

- Eliminate manual deployment activities
- Use OIDC instead of client secrets
- Deploy session hosts from Golden Images
- Implement monitoring before production workloads
- Standardize deployments across environments
- Create reusable Terraform modules
- Document every major design decision

---

## Non-Goals

The following are not required during initial implementation:

```text
Hybrid AD Join

Multi-region DR

Azure Virtual WAN

Multi-tenant AVD
```

These may be introduced in future phases.

---

# 3. Phase Delivery Strategy

The platform will be built in phases.

Each phase has:

- Objective
- Deliverables
- Dependencies
- Success Criteria

A phase is considered complete only when all success criteria are met.

---

# Phase 1 - Bootstrap & OIDC Foundation

## Objective

Create the core deployment foundation.

Establish secure authentication between GitHub and Azure using OIDC.

No infrastructure deployment should occur before this phase is complete.

---

## Deliverables

### Terraform Backend

```text
Resource Group

Storage Account

Blob Container
```

---

### Azure Identity

```text
App Registration

Service Principal

Federated Credentials
```

---

### Role Assignments

```text
Contributor

Storage Blob Data Contributor

User Access Administrator
```

---

### GitHub Workflows

```text
terraform-plan.yml

terraform-apply.yml
```

---

## Dependencies

None

---

## Success Criteria

- Terraform state stored remotely
- GitHub can authenticate using OIDC
- No client secrets exist
- Terraform plan executes successfully

---

# Phase 2 - Repository Framework

## Objective

Establish repository standards and project structure.

---

## Deliverables

### Repository Structure

```text
.github/

bootstrap/

image-factory/

modules/

environments/

docs/
```

---

### Documentation

```text
Architecture.md

NamingConvention.md

Roadmap.md

ModuleContracts.md
```

---

## Dependencies

Phase 1

---

## Success Criteria

- Repository structure finalized
- Naming conventions approved
- Documentation baseline established

---

# Phase 3 - Azure Compute Gallery Foundation

## Objective

Build image infrastructure before any virtual machine deployment.

The platform will use Golden Images from the beginning.

---

## Deliverables

### Azure Compute Gallery

```text
Azure Compute Gallery

Image Definition

Versioning Framework
```

---

### Terraform Module

```text
modules/image-gallery
```

---

## Dependencies

Phase 2

---

## Success Criteria

- Compute Gallery deployed
- Image Definition deployed
- Image versioning strategy documented

---

# Phase 4 - Image Factory

## Objective

Implement automated Golden Image creation.

---

## Deliverables

### Image Factory Components

```text
Packer

Ansible

GitHub Actions Workflow
```

---

### Golden Image Build Workflow

```text
GitHub

  │

  ▼

OIDC

  │

  ▼

Packer

  │

  ▼

Build VM

  │

  ▼

Ansible

  │

  ▼

Sysprep

  │

  ▼

Azure Compute Gallery
```

---

### Initial Software

```text
Windows 11 Enterprise Multi-Session

Azure Monitor Agent

AVD Agent

AVD Bootloader

FSLogix

Microsoft 365 Apps
```

---

## Dependencies

Phase 3

---

## Success Criteria

- Image created automatically
- Image published to gallery
- Image versioning operational
- No manual image capture process exists

---

# Phase 5 - Core Infrastructure Foundation

## Objective

Deploy the core Azure networking resources.

---

## Deliverables

### Networking

```text
Virtual Network

Subnets

Network Security Groups
```

---

### Terraform Modules

```text
resource-group

networking
```

---

## Dependencies

Phase 4

---

## Success Criteria

- Network deployed successfully
- Session host subnet available
- Build subnet available (if required)

---

# Phase 6 - Identity & Access Control

## Objective

Implement role-based access control design.

---

## Deliverables

### Azure AD Groups

```text
AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk
```

---

### Role Assignments

```text
Desktop Virtualization User

Virtual Machine User Login
```

---

### Terraform Module

```text
identity
```

---

## Dependencies

Phase 5

---

## Success Criteria

- No hardcoded user object IDs
- Group-based assignments operational

---

# Phase 7 - Azure Virtual Desktop Core

## Objective

Deploy the AVD control plane.

No session hosts are deployed during this phase.

---

## Deliverables

### Azure Virtual Desktop Resources

```text
Workspace

Host Pool

Application Group

Associations
```

---

### Terraform Modules

```text
avd-workspace

avd-hostpool

avd-appgroup
```

---

## Dependencies

Phase 6

---

## Success Criteria

- Workspace exists
- Host pool exists
- Application group exists
- User assignment model validated

---

# Phase 8 - Monitoring Platform

## Objective

Implement monitoring before deploying session hosts.

---

## Deliverables

### Monitoring Infrastructure

```text
Log Analytics Workspace

Data Collection Rules

Data Collection Rule Associations

Diagnostic Settings

Workbooks

Action Groups

Alerts
```

---

### Monitoring Coverage

#### AVD

```text
WVDConnections

WVDErrors

WVDCheckpoints

WVDManagement
```

---

#### Session Hosts

```text
CPU

Memory

Disk

Heartbeat

Windows Events
```

---

### Terraform Module

```text
monitoring
```

---

## Dependencies

Phase 7

---

## Success Criteria

- Logs reaching Log Analytics
- Workbook deployed
- Alerts functioning
- Monitoring dashboard available

---

# Phase 9 - Session Hosts

## Objective

Deploy session hosts using the Golden Image.

Marketplace images are prohibited.

---

## Deliverables

### Session Hosts

```text
Virtual Machines

Network Interfaces

Managed Disks

Host Pool Registration
```

---

### Image Source

```text
Azure Compute Gallery
```

---

### Terraform Module

```text
session-hosts
```

---

## Dependencies

Phase 8

---

## Success Criteria

- Session hosts use Golden Image
- Session hosts register successfully
- Users can connect

---

# Phase 10 - FSLogix Storage

## Objective

Provide persistent user profile storage.

---

## Storage Options

### Option 1

```text
Azure Files
```

---

### Option 2

```text
Azure NetApp Files
```

---

## Terraform Module

```text
fslogix-storage
```

---

## Dependencies

Phase 9

---

## Success Criteria

- Profiles persist between sessions
- Profile containers operational
- Logons validated successfully

---

# Phase 11 - Enterprise Enhancements

## Objective

Implement advanced operational capabilities.

---

## Scaling

```text
Scaling Plans

Start VM On Connect
```

---

## Security

```text
Microsoft Defender

Azure Policy
```

---

## Operations

```text
Update Manager

Backup

Diagnostics

Cost Management
```

---

## Reporting

```text
Advanced Workbooks

Operational Dashboards

Executive Reporting
```

---

## Dependencies

Phase 10

---

## Success Criteria

- Production-ready platform
- Governance implemented
- Operational visibility established

---

# 4. Environment Strategy

The platform supports:

```text
DEV

TEST

PROD
```

Each environment receives:

```text
Dedicated State File

Dedicated Resource Group

Dedicated Monitoring

Dedicated AVD Resources
```

---

# 5. Development Methodology

Every implementation follows:

```text
Design

Document

Review

Implement

Validate

Commit
```

Infrastructure development shall never begin before documentation is completed.

---

# 6. Definition Of Done

A phase is complete only when:

- Terraform applies successfully
- Documentation is updated
- Outputs are validated
- Monitoring is verified (where applicable)
- Commit comment is recorded
- Code is pushed to repository

---

# 7. Final Platform Outcome

At completion, the platform will provide:

```text
OIDC Authentication

Terraform Deployment

Azure Compute Gallery

Golden Images

Azure Virtual Desktop

Session Hosts

FSLogix

Monitoring

Alerts

GitHub Actions

Multi-Environment Support
```

All infrastructure will be fully automated, fully documented, and deployable through GitHub Actions without manual intervention.