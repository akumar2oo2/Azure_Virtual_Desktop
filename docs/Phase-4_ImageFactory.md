# Phase 4 - Image Factory

# 1. Purpose

Phase 4 introduces the Image Factory.

The Image Factory is responsible for creating, configuring, versioning, and publishing Golden Images into Azure Compute Gallery.

Phase 3 established the image infrastructure.

Phase 4 establishes the image creation process.

The output of this phase is a repeatable image build pipeline capable of publishing versioned images into Azure Compute Gallery.

---

# 2. Scope

The following items are implemented during Phase 4:

```text
Packer Configuration

Ansible Playbook

Ansible Task Files

Image Build Workflow

Golden Image Creation

Azure Compute Gallery Publishing
```

The following items are not implemented during Phase 4:

```text
Session Hosts

Host Pool Registration

Azure Virtual Desktop Resources

FSLogix Storage

Monitoring Infrastructure
```

These components are delivered in later phases.

---

# 3. Repository Structure

Phase 4 utilizes the Image Factory structure established during Phase 2.

```text
image-factory/
│
├── packer.pkr.hcl
│
└── ansible/
    ├── playbook.yml
    │
    └── roles/
        ├── azure-monitor-agent.yml
        ├── fslogix.yml
        └── security-baseline.yml
```

---

# 4. Image Factory Architecture

The Image Factory follows the architecture below.

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

Azure Build VM

      │

      ▼

Ansible

      │

      ▼

Golden Image Configuration

      │

      ▼

Sysprep

      │

      ▼

Azure Compute Gallery

      │

      ▼

Image Version
```

---

# 5. Azure Compute Gallery Consumption

Phase 4 consumes the galleries created during Phase 3.

---

## DEV

```text
AK-AVD-DEV-ACG
```

Image Definition:

```text
AK-WIN11-MS
```

---

## TEST

```text
AK-AVD-TEST-ACG
```

Image Definition:

```text
AK-WIN11-MS
```

---

## PROD

```text
AK-AVD-PROD-ACG
```

Image Definition:

```text
AK-WIN11-MS
```

---

# 6. Golden Image Strategy

The platform maintains a Golden Image for Azure Virtual Desktop deployments.

The Golden Image must remain generic.

Application-specific customizations are out of scope.

---

## Operating System

```text
Windows 11 Enterprise Multi-Session
```

---

## Marketplace Source

Use:

```text
Microsoft Windows 11 Enterprise Multi-Session + Microsoft 365 Apps
```

This eliminates the need to install Microsoft 365 Apps during image creation.

---

# 7. Image Components

The Golden Image includes only essential platform components.

---

## Azure Monitor Agent

Purpose:

```text
Monitoring Integration

Log Analytics Integration

Data Collection Rule Support
```

Implemented through:

```text
azure-monitor-agent.yml
```

---

## FSLogix

Purpose:

```text
Profile Container Support

Azure Virtual Desktop Profile Management
```

Implemented through:

```text
fslogix.yml
```

---

## Security Baseline

Purpose:

```text
Image Hardening

Operating System Security Configuration

Enterprise Style Configuration
```

Implemented through:

```text
security-baseline.yml
```

Configuration Includes:

```text
Enable Microsoft Defender Antivirus

Configure Microsoft recommended Defender exclusions for FSLogix

Enable Windows Firewall for Domain, Private, and Public profiles

Disable SMBv1

Enable Network Level Authentication (NLA)

Disable TLS 1.0

Disable TLS 1.1

Enable TLS 1.2

Apply Microsoft security baseline registry settings

Configure Windows Event Log retention
```

The security baseline is limited to image-level operating system configuration.

Enterprise controls such as Intune policies, Conditional Access, Microsoft Defender for Endpoint onboarding, and device compliance policies are intentionally excluded from the image and remain post-deployment management responsibilities.

---

# 8. Installation Source Strategy

The Image Factory retrieves installation packages from a centralized Azure Storage package repository during the image build process.

The repository does not store installation binaries.

This ensures:

```text
Centralized Software Repository

Version Controlled Installers

Simpler Lifecycle Management

Consistent Image Builds

Reduced Repository Size
```

---

## Package Repository Resources

### Resource Group

```text
AK-RG-PKGS
```

### Storage Account

```text
akavdpackages
```

### Container

```text
packages
```

---

## Required RBAC

The Image Factory uses:

```text
AK-SPN-AVD
```

to authenticate to Azure during the image build process.

The service principal requires the following role assignment on the package repository storage account:

```text
Storage Blob Data Reader
```

Scope:

```text
akavdpackages
```

Purpose:

```text
Allows Packer and Ansible to download installation packages from the package repository during image builds.
```

This role is required because the package repository stores installer files that are consumed during image creation.

---

## Enterprise Note

In enterprise environments, a centralized package management platform such as JFrog Artifactory would typically be used for software distribution and version management.

For this lab, Azure Storage provides a simpler solution while still maintaining the centralized package repository pattern used by enterprise image factories.

---

## Azure Monitor Agent

Installation Source:

```text
Azure Storage Package Repository

AK-RG-PKGS

akavdpackages

packages
```

Installation Method:

```text
Downloaded during image build

Installed through the azure-monitor-agent Ansible task file
```

Purpose:

```text
Monitoring Integration

Log Analytics Integration

Data Collection Rule Support
```

---

## FSLogix

Installation Source:

```text
Azure Storage Package Repository

AK-RG-PKGS

akavdpackages

packages
```

Installation Method:

```text
Downloaded during image build

Installed through the fslogix Ansible task file
```

Purpose:

```text
Profile Container Support

Azure Virtual Desktop Profile Management
```

---

## Security Baseline

Installation Source:

```text
Repository Managed Configuration
```

Installation Method:

```text
Implemented through Ansible tasks

No external binaries required
```

Purpose:

```text
Image Hardening

Configuration Standardization

Enterprise Style Operating System Configuration
```

---

## Expected Repository Contents

Examples:

```text
AzureMonitorAgent.msi

FSLogix.zip
```

---

## Component Delivery Flow

```text
Azure Storage Package Repository

      │

      ▼

Packer Build VM

      │

      ▼

Ansible Playbook

      │

      ├── Download Azure Monitor Agent

      ├── Download FSLogix

      └── Apply Security Baseline

      │

      ▼

Golden Image

      │

      ▼

Azure Compute Gallery
```

---

## Repository Responsibility

The repository stores:

```text
Packer Configuration

Ansible Playbook

Ansible Task Files

Configuration Logic
```

The repository does not store:

```text
Azure Monitor Agent Installers

FSLogix Installers

Third-Party Installation Binaries
```

Installation packages are retrieved from:

```text
AK-RG-PKGS

akavdpackages

packages
```

during the image build process.

---

# 9. Packer Configuration

Packer is responsible for:

```text
Build VM Creation

Ansible Execution

Image Capture

Gallery Publishing
```

---

## File

```text
image-factory/packer.pkr.hcl
```

---

## Responsibilities

```text
Authenticate To Azure

Deploy Temporary Build VM

Execute Ansible

Generalize Image

Publish To Gallery
```

---

# 10. Ansible Architecture

The platform uses task-based Ansible automation.

A single orchestration playbook controls image creation.

Each image component is implemented as an independent task file located within the roles directory.

This approach keeps the Image Factory simple while maintaining separation of responsibilities.

---

## Playbook

```text
image-factory/ansible/playbook.yml
```

Purpose:

```text
Image Build Orchestration
```

---

## Task Files

```text
azure-monitor-agent.yml

fslogix.yml

security-baseline.yml
```

Each task file is independently maintained and is responsible for a specific image component.

---

# 11. Build Image Playbook

The build playbook orchestrates task execution.

Example:

```yaml
---
- name: Build Azure Virtual Desktop Golden Image
  hosts: localhost

  tasks:

    - name: Install FSLogix
      include_tasks: roles/fslogix.yml

    - name: Apply Security Baseline
      include_tasks: roles/security-baseline.yml

    - name: Install Azure Monitor Agent
      include_tasks: roles/azure-monitor-agent.yml
```

---

## Responsibilities

```text
Task Execution Order

Image Configuration

Image Standardization

Azure Compute Gallery Publishing Preparation
```

---

# 12. Image Versioning Strategy

Phase 4 follows the versioning model established in Phase 3.

---

## Version Format

```text
Major.Minor.Patch
```

Examples:

```text
1.0.0

1.1.0

1.1.1

2.0.0
```

---

## Major

```text
Operating System Upgrade

Major Architectural Change
```

---

## Minor

```text
Feature Addition

Configuration Enhancement
```

---

## Patch

```text
Security Update

Bug Fix

Maintenance Release
```

---

# 13. Image Publishing Process

Once the image is generalized, it is published to the selected gallery.

Example:

```text
AK-AVD-DEV-ACG
    │
    ▼
AK-WIN11-MS
    │
    ▼
1.0.0
```

Future releases:

```text
1.1.0

1.1.1

2.0.0
```

are published to the same image definition.

---

# 14. GitHub Workflow

Phase 4 introduces the image build workflow.

Example:

```text
build-image.yml
```

Purpose:

```text
Trigger Image Build

Run Packer

Execute Ansible

Publish Image
```

---

## Authentication

Uses:

```text
AK-SPN-AVD

AK-GitHub-OIDC
```

established during Phase 1.

---

# 15. Validation Checklist

Verify:

```text
packer.pkr.hcl Created

playbook.yml Created

playbook.yml Executes Successfully

Azure Monitor Agent Installed

FSLogix Installed

Security Baseline Applied

Image Hardening Completed

Golden Image Successfully Generalized

Image Published To Azure Compute Gallery

Image Version Available
```

---

# 16. Exit Criteria

Phase 4 is complete when:

```text
Packer Configuration Created

Ansible Playbook Created

Ansible Task Files Created

Image Build Workflow Created

Golden Image Published

Versioned Image Available In Azure Compute Gallery
```

The image must be consumable by future Session Host deployments.

---

# 17. Next Phase

Upon completion of Phase 4 the project moves to:

```text
Phase 5 - Core Infrastructure
```

Phase 5 introduces:

```text
Resource Groups

Networking

Virtual Network

Subnets

Network Security Groups
```