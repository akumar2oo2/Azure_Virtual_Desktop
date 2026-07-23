# Azure Virtual Desktop Enterprise Platform Architecture

# 1. Overview

This repository implements a complete Azure Virtual Desktop (AVD) platform using modern cloud engineering and Infrastructure as Code (IaC) practices.

The platform is designed around:

- Terraform
- OIDC Authentication
- GitHub Actions
- Azure Compute Gallery
- Golden Images
- FSLogix
- Enterprise Monitoring
- Multi-Environment Deployments
- Documentation Driven Development

The goal is to build a predictable, maintainable, and fully automated Azure Virtual Desktop platform with complete ownership of every component.

---

# 2. Architecture Principles

## Principle 1 - OIDC Authentication

GitHub Actions must authenticate to Azure using OIDC Federation.

No client secrets shall be used.

### Approved Authentication Flow

```text
GitHub Actions

      │

      ▼

OIDC Token

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

### Prohibited Authentication Methods

```text
Client Secret

Username

Password

Personal Access Token
```

---

## Principle 2 - Golden Image First

All session hosts must be deployed from Azure Compute Gallery images.

Marketplace images shall never be used directly for AVD session host deployment.

### Approved Image Flow

```text
Packer

   │

   ▼

Ansible

   │

   ▼

Golden Image

   │

   ▼

Azure Compute Gallery

   │

   ▼

Session Hosts
```

---

## Principle 3 - Modular Terraform

Every workload must exist in its own Terraform module.

Modules communicate only through:

```text
Variables

Outputs
```

Modules must never directly reference resources from another module.

---

## Principle 4 - Monitoring by Design

Monitoring must exist before session hosts are deployed.

Every deployed component must support:

```text
Logs

Metrics

Alerts

Workbooks
```

---

## Principle 5 - Documentation Driven Development

Documentation must be completed before implementation.

Required documents:

```text
Architecture.md

NamingConvention.md

Roadmap.md

ModuleContracts.md
```

---

# 3. Repository Structure

```text
Azure_Virtual_Desktop/
│
├── .github/
│   └── workflows/
│
├── image-factory/
│   ├── packer/
│   ├── ansible/
│   └── scripts/
│
├── modules/
│   ├── resource-group/
│   ├── networking/
│   ├── identity/
│   ├── image-gallery/
│   ├── monitoring/
│   ├── avd-workspace/
│   ├── avd-hostpool/
│   ├── avd-appgroup/
│   ├── session-hosts/
│   └── fslogix-storage/
│
├── environments/
│   ├── dev.tfvars
│   ├── test.tfvars
│   └── prod.tfvars
│
├── docs/
│
├── providers.tf
├── versions.tf
├── main.tf
├── variables.tf
└── outputs.tf
```

---

# 4. Bootstrap Architecture

The platform bootstrap process is intentionally manual.

Terraform does not deploy its own bootstrap components.

---

## Bootstrap Resources

The following resources are manually created once:

```text
AK-RG-TFSTATE

aksttfstate

tfstate

AK-SPN-AVD

AK-GitHub-OIDC
```

---

## Bootstrap Process

```text
Azure Portal

      │

      ▼

Create Resource Group

      │

      ▼

Create Storage Account

      │

      ▼

Create Blob Container

      │

      ▼

Create App Registration

      │

      ▼

Create Federated Credential

      │

      ▼

Assign RBAC

      │

      ▼

Validate GitHub Authentication
```

---

## Bootstrap Principle

Terraform begins only after:

```text
OIDC Authentication

Remote State

RBAC Assignments
```

have been successfully established.

---

# 5. Identity Architecture

The platform uses a single deployment identity.

---

## App Registration

```text
AK-SPN-AVD
```

Responsibilities:

```text
Terraform Deployments

Image Factory

Azure Compute Gallery

Azure Virtual Desktop

Monitoring

Networking

Future Platform Components
```

---

## Federated Credential

```text
AK-GitHub-OIDC
```

Used by:

```text
GitHub Actions
```

---

## RBAC Design

Initial Role Assignments:

```text
Contributor

Storage Blob Data Contributor
```

Future role assignments may be added as required.

---

# 6. High-Level Platform Architecture

```text
                           GitHub

                              │

                              ▼

                       GitHub Actions

                              │

                              ▼

                     OIDC Authentication

                              │

                              ▼

                         AK-SPN-AVD

                              │

                              ▼

                     Azure Subscription

                              │

    ┌─────────────────────────┼─────────────────────────┐

    │                         │                         │

    ▼                         ▼                         ▼

Compute Gallery         Terraform Core          Monitoring

    │                         │                         │

    ▼                         ▼                         ▼

Golden Images        Platform Resources      Log Analytics

    │

    ▼

Session Hosts

    │

    ▼

FSLogix
```

---

# 7. Image Factory Architecture

Image Factory is a first-class platform component.

Session hosts depend on image availability.

---

## Image Build Process

```text
GitHub Workflow

       │

       ▼

OIDC Login

       │

       ▼

Build VM

       │

       ▼

Packer

       │

       ▼

Ansible

       │

       ▼

Operating System Configuration

       │

       ▼

Sysprep

       │

       ▼

Azure Compute Gallery
```

---

## Golden Image Contents

### Operating System

```text
Windows 11 Enterprise Multi-Session
```

### Installed Components

```text
Azure Monitor Agent

AVD Agent

AVD Bootloader

FSLogix

Microsoft 365 Apps
```

---

## Future Components

```text
OneDrive

Microsoft Teams

Enterprise Applications

Security Baselines
```

---

# 8. Azure Virtual Desktop Architecture

The AVD control plane is deployed before session hosts.

---

## Components

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

### Desktop Application Group

```text
AK-AVD-<ENV>-DAG
```

---

### Remote Application Group

```text
AK-AVD-<ENV>-RAG
```

---

## Connection Flow

```text
User

  │

  ▼

Workspace

  │

  ▼

Application Group

  │

  ▼

Host Pool

  │

  ▼

Session Host
```

---

# 9. Session Host Architecture

Session hosts are always deployed from Azure Compute Gallery.

---

## Session Host Flow

```text
Azure Compute Gallery

         │

         ▼

Golden Image

         │

         ▼

Session Host VM

         │

         ▼

AVD Registration

         │

         ▼

Host Pool
```

---

## Session Host Responsibilities

```text
User Sessions

FSLogix Connectivity

Monitoring Data

AVD Registration
```

---

# 10. Monitoring Architecture

Monitoring is delivered before production workloads.

---

## Components

```text
Log Analytics Workspace

Diagnostic Settings

Data Collection Rules

Data Collection Rule Associations

Workbook

Action Groups

Alerts
```

---

## AVD Monitoring Scope

```text
WVDConnections

WVDErrors

WVDCheckpoints

WVDManagement
```

---

## Session Host Monitoring Scope

```text
CPU

Memory

Disk

Heartbeat

Windows Events
```

---

## Monitoring Pipeline

```text
Azure Resources

      │

      ▼

Diagnostic Settings

      │

      ▼

Log Analytics Workspace

      │

      ▼

Workbook

Alerts

Action Groups
```

---

# 11. FSLogix Architecture

FSLogix is installed during image creation.

Session hosts consume FSLogix rather than configure it.

---

## Profile Flow

```text
User

   │

   ▼

Session Host

   │

   ▼

FSLogix

   │

   ▼

Profile Storage
```

---

## Supported Storage

```text
Azure Files

Azure NetApp Files
```

---

# 12. CI/CD Architecture

All deployments originate from GitHub Actions.

---

## Terraform Deployment Flow

```text
GitHub Workflow

       │

       ▼

Environment Selection

       │

       ▼

OIDC Authentication

       │

       ▼

Terraform Validate

       │

       ▼

Terraform Plan

       │

       ▼

Terraform Apply

       │

       ▼

Azure Resources
```

---

## Environment Strategy

A single workflow supports:

```text
DEV

TEST

PROD
```

The selected environment determines:

```text
Terraform Variables

Deployment Scope

Resource Naming

Terraform State
```

Authentication remains:

```text
AK-GitHub-OIDC

AK-SPN-AVD
```

for all environments.

---

# 13. Future Platform Enhancements

Planned future capabilities:

```text
Scaling Plans

Azure Policy

Microsoft Defender

Backup

Update Manager

Executive Dashboards

Advanced Reporting

Cost Management
```

---

# 14. Architecture Summary

The platform is built around five core pillars:

```text
OIDC Authentication

Golden Image Strategy

Modular Terraform

Enterprise Monitoring

Automated Delivery
```

Every component of the Azure Virtual Desktop platform must align with these principles.