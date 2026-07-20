# Azure Virtual Desktop Enterprise Platform Roadmap

# 1. Project Overview

The objective of this project is to build a production-ready Azure Virtual Desktop platform using modern cloud engineering practices.

The platform will be:

- Terraform Managed
- GitHub Actions Driven
- OIDC Authenticated
- Azure Compute Gallery Integrated
- Golden Image Based
- FSLogix Enabled
- Enterprise Monitored
- Multi-Environment Ready
- Fully Documented

The platform must be maintainable, repeatable, secure, and fully understood by platform operators.

---

# 2. Guiding Principles

## OIDC Authentication

Authentication must use:

```text
GitHub Actions

OIDC

Federated Credential

AK-SPN-AVD
```

Client secrets are prohibited.

---

## Golden Image Strategy

Session Hosts must be deployed only from:

```text
Azure Compute Gallery
```

Marketplace images shall not be used directly.

---

## Documentation First

Documentation precedes implementation.

Required documents:

```text
Architecture.md

NamingConvention.md

Roadmap.md

ModuleContracts.md
```

must be maintained throughout the project lifecycle.

---

## Modular Design

Every major workload must exist as an independent Terraform module.

---

## Monitoring By Design

Monitoring must be implemented before production session hosts are deployed.

---

# 3. Project Phases

The platform is delivered in phases.

Each phase contains:

```text
Objective

Deliverables

Dependencies

Success Criteria
```

Implementation begins only after design and documentation are complete.

---

# Phase 1A - Manual Bootstrap

# Objective

Create the foundational components required before Terraform can authenticate to Azure.

Bootstrap resources are intentionally created manually.

Terraform does not manage bootstrap resources.

---

## Deliverables

### Terraform Backend Resources

```text
AK-RG-TFSTATE

akavdtfstate

tfstate
```

---

### Azure Identity

```text
AK-SPN-AVD

AK-GitHub-OIDC
```

---

### RBAC Assignments

```text
Contributor

Storage Blob Data Contributor
```

---

### GitHub Repository Configuration

```text
GitHub Repository

GitHub Environments

GitHub Permissions
```

---

## Dependencies

None

---

## Success Criteria

```text
Storage Account Created

Terraform State Container Created

App Registration Created

Federated Credential Created

RBAC Verified
```

---

# Phase 1B - OIDC Validation

# Objective

Validate GitHub authentication to Azure before infrastructure deployment begins.

---

## Deliverables

### GitHub Workflow

```text
terraform-plan.yml
```

---

### Authentication Validation

```text
GitHub Actions

      │

      ▼

OIDC

      │

      ▼

AK-GitHub-OIDC

      │

      ▼

AK-SPN-AVD

      │

      ▼

Azure Subscription
```

---

## Dependencies

Phase 1A

---

## Success Criteria

```text
GitHub Authentication Successful

Azure Login Successful

Terraform Init Successful

Terraform Validate Successful
```

---

# Phase 2 - Repository Framework

# Objective

Establish the repository structure and coding standards.

---

## Deliverables

### Repository Structure

```text
.github

image-factory

modules

environments

docs
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

### Repository Standards

```text
Terraform Standards

Documentation Standards

Naming Standards
```

---

## Dependencies

Phase 1B

---

## Success Criteria

```text
Repository Structure Approved

Documentation Approved

Standards Finalized
```

---

# Phase 3 - Azure Compute Gallery Foundation

# Objective

Create image infrastructure before any virtual machine deployment.

---

## Deliverables

### Azure Compute Gallery

```text
AK-AVD-ACG
```

---

### Image Definition

```text
AK-WIN11-MS
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

```text
Compute Gallery Deployed

Image Definition Created

Image Versioning Strategy Defined
```

---

# Phase 4 - Image Factory

# Objective

Implement automated Golden Image creation.

---

## Deliverables

### Packer

```text
Windows Image Build
```

---

### Ansible

```text
Image Configuration
```

---

### GitHub Workflow

```text
build-image.yml
```

---

## Initial Software

### Operating System

```text
Windows 11 Enterprise Multi-Session
```

---

### Components

```text
Azure Monitor Agent

AVD Agent

AVD Bootloader

FSLogix

Microsoft 365 Apps
```

---

## Image Build Flow

```text
GitHub Actions

      │

      ▼

OIDC Authentication

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

## Dependencies

Phase 3

---

## Success Criteria

```text
Golden Image Builds Successfully

Image Published To Gallery

Versioning Operational

No Manual Image Creation
```

---

# Phase 5 - Core Infrastructure Foundation

# Objective

Deploy foundational Azure resources.

---

## Deliverables

### Resource Group Module

```text
modules/resource-group
```

---

### Networking Module

```text
modules/networking
```

---

### Resources

```text
Virtual Network

Subnets

Network Security Groups
```

---

## Dependencies

Phase 4

---

## Success Criteria

```text
Networking Operational

Subnets Available

Platform Ready For AVD
```

---

# Phase 6 - Identity & Access Control

# Objective

Implement group-based access management.

---

## Deliverables

### Azure AD Groups

```text
AK-AVD-Admins

AK-AVD-Users

AK-AVD-Helpdesk
```

---

### RBAC

```text
Desktop Virtualization User

Virtual Machine User Login
```

---

### Terraform Module

```text
modules/identity
```

---

## Dependencies

Phase 5

---

## Success Criteria

```text
Group-Based Access Control Working

No Hardcoded Object IDs
```

---

# Phase 7 - Azure Virtual Desktop Core

# Objective

Deploy AVD control-plane resources.

Session Hosts are not deployed during this phase.

---

## Deliverables

### Workspace

```text
AK-AVD-<ENV>-WS
```

---

### Host Pool

```text
AK-AVD-<ENV>-HP
```

---

### Application Groups

```text
AK-AVD-<ENV>-DAG

AK-AVD-<ENV>-RAG
```

---

### Terraform Modules

```text
modules/avd-workspace

modules/avd-hostpool

modules/avd-appgroup
```

---

## Dependencies

Phase 6

---

## Success Criteria

```text
Workspace Operational

Host Pool Created

Application Group Created

Assignments Verified
```

---

# Phase 8 - Monitoring Platform

# Objective

Implement monitoring before session host deployment.

---

## Deliverables

### Log Analytics Workspace

```text
AK-AVD-<ENV>-LAW
```

---

### Monitoring Components

```text
Data Collection Rules

Diagnostic Settings

Workbook

Action Groups

Alerts
```

---

### Terraform Module

```text
modules/monitoring
```

---

## AVD Monitoring

```text
WVDConnections

WVDErrors

WVDCheckpoints

WVDManagement
```

---

## Session Host Monitoring

```text
CPU

Memory

Disk

Heartbeat

Windows Events
```

---

## Dependencies

Phase 7

---

## Success Criteria

```text
Logs Available

Workbook Operational

Alerting Operational

Monitoring Validated
```

---

# Phase 9 - Session Hosts

# Objective

Deploy session hosts from Golden Images.

Marketplace images are prohibited.

---

## Deliverables

### Session Hosts

```text
Virtual Machines

NICs

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
modules/session-hosts
```

---

## Dependencies

Phase 8

---

## Success Criteria

```text
Session Hosts Deployed

Host Pool Registration Successful

User Connectivity Validated
```

---

# Phase 10 - FSLogix Storage

# Objective

Provide persistent profile storage.

---

## Storage Options

### Azure Files

```text
Preferred Initial Implementation
```

---

### Azure NetApp Files

```text
Future Enhancement
```

---

### Terraform Module

```text
modules/fslogix-storage
```

---

## Dependencies

Phase 9

---

## Success Criteria

```text
Profile Persistence Working

FSLogix Operational

User Logons Validated
```

---

# Phase 11 - Enterprise Enhancements

# Objective

Add enterprise capabilities after the core platform is stable.

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
Executive Dashboards

Advanced Workbooks

Operational Dashboards
```

---

## Dependencies

Phase 10

---

## Success Criteria

```text
Production Ready Platform

Governance Implemented

Operational Standards Established
```

---

# 4. Environment Strategy

Supported environments:

```text
DEV

TEST

PROD
```

A single deployment workflow supports all environments.

Environment selection determines:

```text
Terraform Variables

Terraform State

Resource Naming

Deployment Scope
```

Authentication always uses:

```text
AK-SPN-AVD

AK-GitHub-OIDC
```

---

# 5. Development Methodology

All implementations follow:

```text
Design

Document

Review

Implement

Validate

Commit
```

Documentation must be updated when architectural decisions change.

---

# 6. Definition Of Done

A phase is considered complete only when:

```text
Terraform Validate Successful

Terraform Plan Successful

Outputs Verified

Documentation Updated

Commit Comment Recorded

Code Committed
```

---

# 7. Final Platform Outcome

The completed platform will provide:

```text
OIDC Authentication

GitHub Actions

Terraform Automation

Azure Compute Gallery

Golden Images

Azure Virtual Desktop

Session Hosts

FSLogix

Monitoring

Alerts

Multi-Environment Support
```

This platform will be fully automated, fully documented, and deployable through GitHub Actions without manual infrastructure operations.