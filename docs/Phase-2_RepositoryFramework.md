# Phase 2 - Repository Framework

# 1. Purpose

Phase 2 establishes the repository framework that will be used throughout the Azure Virtual Desktop platform lifecycle.

No Azure resources are deployed during this phase.

The objective is to create the repository structure, Terraform foundation files, module structure, Image Factory structure, and GitHub workflow framework that all future phases will consume.

This phase focuses only on repository organization and platform structure.

---

# 2. Scope

The following items are implemented during Phase 2:

```text
Repository Structure

Terraform Root Files

Module Structure

Image Factory Structure

GitHub Workflow Structure

Environment Structure
```

The following items are not implemented during Phase 2:

```text
Azure Compute Gallery

Images

Networking

Identity

Monitoring

Azure Virtual Desktop

Session Hosts

FSLogix Infrastructure
```

Those components are delivered in later phases.

---

# 3. Repository Structure

```text
Azure_Virtual_Desktop/
│
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml
│       └── terraform-apply.yml
│
├── image-factory/
│   │
│   ├── packer.pkr.hcl
│   │
│   └── ansible/
│       ├── playbook.yml
│       └── roles/
│           ├── azure-monitor-agent.yml
│           ├── fslogix.yml
│           └── security-baseline.yml
│
├── modules/
│   ├── resource-group/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── networking/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── identity/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── image-gallery/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── monitoring/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
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
│   ├── avd-appgroup/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── session-hosts/
│   │   ├── versions.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── fslogix-storage/
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
├── docs/
│
├── backend.hcl
├── versions.tf
├── providers.tf
├── locals.tf
├── variables.tf
├── outputs.tf
└── main.tf
```

---

# 4. Terraform Root Files

The root Terraform files provide the platform foundation.

---

## backend.hcl

Purpose:

```text
Terraform Remote State Configuration
```

---

## versions.tf

Purpose:

```text
Terraform Version Control

Provider Version Control
```

---

## providers.tf

Purpose:

```text
Provider Configuration
```

---

## locals.tf

Purpose:

```text
Platform Constants

Naming Logic

Environment Logic
```

---

## variables.tf

Purpose:

```text
Root Module Inputs
```

---

## outputs.tf

Purpose:

```text
Root Module Outputs
```

---

## main.tf

Purpose:

```text
Platform Module Orchestration
```

No Azure resources are deployed during this phase.

---

# 5. Module Structure Standard

Every Terraform module follows the same structure.

```text
module-name/

├── versions.tf
├── main.tf
├── variables.tf
└── outputs.tf
```

The repository uses phase-based documentation.

Therefore:

```text
README.md
```

inside modules is not required.

Module documentation is maintained in the corresponding phase document.

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

# 6. Image Factory Structure

The Image Factory is designed as an independent platform component.

---

## Packer Structure

```text
image-factory/
└── packer.pkr.hcl
```

Purpose:

```text
Image Building

Image Configuration Inputs

Image Build Automation
```

---

## Ansible Structure

```text
image-factory/
└── ansible/
    ├── playbook.yml
    └── roles/
        ├── azure-monitor-agent.yml
        ├── fslogix.yml
        └── security-baseline.yml
```

---

# 7. Ansible Role Architecture

The platform uses a task-based Ansible design.

A single orchestration playbook controls image creation.

Each image component is implemented as an independent task file located inside the roles directory.

This approach keeps the Image Factory lightweight while maintaining separation of responsibilities.

---

## Roles

```text
azure-monitor-agent.yml

fslogix.yml

security-baseline.yml
```

Each role is responsible only for its workload.

---

### azure-monitor-agent

Purpose:

```text
Installs and configures Azure Monitor Agent.
```

---

### fslogix

Purpose:

```text
Installs FSLogix.
```

---

### security-baseline

Purpose:

```text
Applies operating system hardening and baseline security configuration for Azure Virtual Desktop session host images.
```

Configuration Includes:

```text
Enable Microsoft Defender Antivirus

Configure Microsoft recommended Defender exclusions for FSLogix

Enable Windows Firewall for Domain, Private, and Public profiles

Disable SMBv1

Enable Network Level Authentication (NLA) for Remote Desktop

Disable TLS 1.0

Disable TLS 1.1

Enable TLS 1.2

Apply Microsoft security baseline registry settings

Configure Windows Event Log retention
```

This role is responsible for implementing image-level security controls that should exist before the image is published to Azure Compute Gallery.

The role does not implement enterprise services such as Microsoft Defender for Endpoint onboarding, Intune policies, Conditional Access policies, or Endpoint Manager configuration.

These controls remain external to the image and are managed by platform operations after deployment.

---

## Benefits

```text
Independent Role Lifecycle

Simpler Maintenance

Versionable Components

Reusable Automation

Cleaner Image Builds
```

---

# 8. Build Image Playbook

Image creation is orchestrated through:

```text
image-factory/ansible/playbook.yml
```

This playbook acts as the orchestration layer.

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

Responsibilities:

```text
Task Execution Order

Component-Based Image Configuration

Image Build Orchestration

Standardized Image Creation

Azure Compute Gallery Publishing Preparation
```

---

# 9. GitHub Workflow Structure

The workflow directory structure is:

```text
.github/
└── workflows/
    ├── terraform-plan.yml
    └── terraform-apply.yml
```

Additional workflows will be introduced in future phases.

Examples:

```text
build-image.yml

release-image.yml

destroy-environment.yml
```

---

# 10. Validation Checklist

Verify:

```text
Repository Structure Created

Root Terraform Files Created

Module Directories Created

Image Factory Structure Created

GitHub Workflow Structure Created

Environment Files Created
```

---

# 11. Exit Criteria

Phase 2 is complete when:

```text
Repository Framework Established

Terraform Root Files Created

Module Structure Created

Image Factory Structure Created

GitHub Workflow Structure Created

Environment Structure Created
```

No Azure resources are deployed during this phase.

---

# 12. Next Phase

Upon completion of Phase 2 the project moves to:

```text
Phase 3 - Azure Compute Gallery Foundation
```

Phase 3 introduces the first Azure resources:

```text
Azure Compute Gallery

Image Definition

Image Versioning Foundation
```