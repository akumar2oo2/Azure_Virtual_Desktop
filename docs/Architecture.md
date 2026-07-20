# Azure Virtual Desktop Enterprise Platform Architecture

# 1. Overview

This repository implements a complete Azure Virtual Desktop (AVD) platform using modern cloud engineering and Infrastructure as Code (IaC) practices.

The platform is designed around the following principles:

- Infrastructure as Code (Terraform)
- OIDC-based authentication
- GitHub Actions CI/CD
- Enterprise modular architecture
- Golden Image deployment strategy
- Azure Compute Gallery integration
- Monitoring and observability by design
- Repeatable deployments
- Multi-environment support
- No client secrets
- No manual image management

---

# 2. Architecture Principles

## Principle 1 - OIDC First

Authentication between GitHub and Azure must use OIDC federation.

Client secrets are prohibited.

### Approved Flow

```text
GitHub Actions
       │
       ▼
OIDC Token
       │
       ▼
Azure App Registration
       │
       ▼
Azure Resources
```

### Not Allowed

```text
GitHub Secret
Client Secret
Username
Password
```

---

## Principle 2 - Golden Image First

Session hosts shall never be deployed from Marketplace images.

All session hosts must be deployed from internally managed images stored in Azure Compute Gallery.

### Approved Flow

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

Each component must be implemented as an independent Terraform module.

Modules communicate only through:

- Variables
- Outputs

Modules must never reference each other internally.

---

## Principle 4 - Monitoring by Design

Monitoring must exist before session hosts are deployed.

Monitoring is not an afterthought.

All AVD components must publish logs and metrics into Azure Monitor.

---

## Principle 5 - Documentation Driven Development

Every module requires:

```text
README.md
main.tf
variables.tf
outputs.tf
versions.tf
```

Documentation is part of the deliverable.

---

# 3. Repository Structure

```text
Azure_Virtual_Desktop/
│
├── .github/
│   └── workflows/
│
├── bootstrap/
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

# 4. High-Level Platform Architecture

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

                           Azure Tenant

                                 │

                 ┌───────────────┼───────────────┐

                 │                               │

                 ▼                               ▼

       Azure Compute Gallery               Terraform

                 │                               │

                 ▼                               ▼

          Golden Images                  Azure Resources

                                                 │

                     ┌───────────────────────────┼───────────────────────────┐

                     │                           │                           │

                     ▼                           ▼                           ▼

                 Networking                  AVD Core                 Monitoring

                     │                           │                           │

                     └───────────────┬───────────┴───────────────┬──────────┘

                                     │

                                     ▼

                                Session Hosts

                                     │

                                     ▼

                                 FSLogix
```

---

# 5. Image Factory Architecture

Image management is a first-class component of the platform.

Session hosts are dependent upon image creation.

---

## Image Build Flow

```text
GitHub Workflow

      │

      ▼

OIDC Login

      │

      ▼

Azure Build VM

      │

      ▼

Packer

      │

      ▼

Ansible

      │

      ▼

Windows Configuration

      │

      ▼

Sysprep

      │

      ▼

Capture Image

      │

      ▼

Azure Compute Gallery

      │

      ▼

Image Version Published
```

---

## Golden Image Contents

### Operating System

```text
Windows 11 Enterprise Multi-Session
```

### Required Components

```text
Azure Monitor Agent

AVD Agent

AVD Bootloader

FSLogix

Microsoft 365 Apps
```

### Future Components

```text
OneDrive

Teams

Custom Applications

Security Baselines

Hardening Controls
```

---

# 6. Azure Virtual Desktop Architecture

Control plane resources are deployed before session hosts.

---

## Components

### Workspace

Provides user entry point.

```text
AK-AVD-<ENV>-WS
```

---

### Host Pool

Provides AVD session management.

```text
AK-AVD-<ENV>-HP
```

---

### Application Group

Publishes desktops and applications.

```text
AK-AVD-<ENV>-DAG

AK-AVD-<ENV>-RAG
```

---

## AVD Flow

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

Session Hosts
```

---

# 7. Session Host Architecture

Session hosts use Compute Gallery images only.

### Image Source

```text
Azure Compute Gallery
```

### Deployment

```text
Image Version

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

# 8. Monitoring Architecture

Monitoring is deployed before session hosts.

---

## Components

### Log Analytics Workspace

Central monitoring repository.

### Data Collection Rules

Collect:

```text
CPU

Memory

Disk

Events

Performance Data
```

### Diagnostic Settings

Collect:

```text
WVDConnections

WVDErrors

WVDCheckpoints

WVDManagement
```

### Workbook

Single-pane-of-glass monitoring dashboard.

### Alerts

Operational alerting.

---

# Monitoring Flow

```text
Host Pool

Workspace

Application Group

Session Hosts

       │

       ▼

Diagnostic Settings

       │

       ▼

Log Analytics Workspace

       │

       ▼

Workbooks

Alerts

Action Groups
```

---

# 9. FSLogix Architecture

FSLogix is installed during image creation.

Session hosts do not configure FSLogix locally.

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

Profile Container Storage
```

### Backend Storage Options

```text
Azure Files

or

Azure NetApp Files
```

---

# 10. CI/CD Architecture

All deployments originate from GitHub Actions.

---

## Infrastructure Deployment

```text
GitHub

   │

   ▼

Terraform Plan

   │

   ▼

Approval

   │

   ▼

Terraform Apply

   │

   ▼

Azure Resources
```

---

## Image Deployment

```text
GitHub

   │

   ▼

Image Build Workflow

   │

   ▼

Packer

   │

   ▼

Ansible

   │

   ▼

Azure Compute Gallery
```

---

# 11. Future Growth

The architecture is designed to support:

```text
DEV

TEST

PROD
```

and future enhancements such as:

```text
Scaling Plans

Defender for Cloud

Azure Policy

Backup

Update Manager

Cost Management

Advanced Reporting

Executive Dashboards
```

without requiring redesign.

---

# Architecture Summary

The Azure Virtual Desktop Enterprise Platform is built around five pillars:

1. OIDC Authentication
2. Golden Image Strategy
3. Modular Terraform
4. Enterprise Monitoring
5. Automated Delivery

This architecture ensures secure, repeatable, and maintainable Azure Virtual Desktop deployments at enterprise scale.