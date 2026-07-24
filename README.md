# Azure Virtual Desktop Enterprise Platform

# Overview

Azure Virtual Desktop Enterprise Platform is a fully automated Azure Virtual Desktop solution built using modern cloud engineering practices.

The platform is designed around:

- Terraform
- GitHub Actions
- OIDC Authentication
- Azure Compute Gallery
- Golden Images
- Packer
- Ansible
- FSLogix
- Enterprise Monitoring
- Multi-Environment Deployments

The goal is to build a platform that is secure, repeatable, maintainable, and fully understood from the beginning.

---

# Core Design Principles

## OIDC Authentication

Authentication between GitHub and Azure uses:

```text
OIDC Federation
```

No client secrets are used.

---

## Golden Image Strategy

All session hosts are deployed from:

```text
Azure Compute Gallery
```

Marketplace images are not used directly.

---

## Modular Terraform

Every workload is implemented as an independent Terraform module.

Modules communicate through:

```text
Variables

Outputs
```

---

## Documentation Driven Development

Design decisions are documented before implementation begins.

Documentation always drives implementation.

---

# Repository Structure

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
├── variables.tf
├── outputs.tf
└── main.tf
```

---

# Documentation Structure

The repository uses a phase-based documentation model.

## Why Phase-Based Documentation

The objective is to allow anyone reading the repository to understand:

```text
What was built

Why it was built

When it was built

How the implementation evolved
```

without reading every commit individually.

---

## Documentation Format

```text
Phase-0_Architecture.md

Phase-0_NamingConvention.md

Phase-0_Roadmap.md

Phase-0_ModuleContracts.md

Phase-1_Bootstrap.md

Phase-2_<PhaseName>.md

Phase-3_<PhaseName>.md

Phase-4_<PhaseName>.md
```

Future phases will follow the same format.

---

# How To Read The Documentation

The recommended reading order is:

## 1. Architecture

```text
Phase-0_Architecture.md
```

Explains:

```text
Platform Architecture

OIDC Model

Image Factory

AVD Architecture

Monitoring Architecture

CI/CD Architecture
```

---

## 2. Naming Standards

```text
Phase-0_NamingConvention.md
```

Explains:

```text
Resource Naming

Image Naming

Terraform Naming

GitHub Naming

Identity Naming
```

---

## 3. Roadmap

```text
Phase-0_Roadmap.md
```

Explains:

```text
Project Phases

Objectives

Dependencies

Implementation Order
```

---

## 4. Module Standards

```text
Phase-0_ModuleContracts.md
```

Explains:

```text
Terraform Standards

Module Layout

Variables

Outputs

Dependencies
```

---

## 5. Current Phase

Read the phase document currently being implemented.

Example:

```text
Phase-1_Bootstrap.md
```

This document contains the implementation guide for that specific phase.

---

# Commit Strategy

The repository follows a phase-based commit strategy.

Every feature introduced should clearly indicate:

```text
Phase

Feature

Implementation Progress
```

---

## Commit Format

Pattern:

```text
<type>(phase-x): <description>
```

Examples:

```text
feat(phase-1): add terraform backend bootstrap documentation

feat(phase-1): add OIDC authentication workflow

feat(phase-2): create repository framework structure

feat(phase-3): add Azure Compute Gallery module

feat(phase-4): add image factory workflow

feat(phase-5): create networking module
```

---

## Documentation Commits

Examples:

```text
docs(phase-0): add platform architecture

docs(phase-0): add naming convention standards

docs(phase-1): add bootstrap implementation guide
```

---

# Why This Commit Strategy Exists

The goal is to allow someone to:

```text
Read Documentation
       │
       ▼
Read Commits
       │
       ▼
Watch Platform Evolution
```

step by step.

The documentation and commit history should tell the same story.

Anyone reviewing the repository should be able to understand exactly how the platform was built from start to finish.

---

# Current Implementation Phase

Current Phase:

```text
Phase 1A - Manual Bootstrap
```

Current Objectives:

```text
Terraform Backend

App Registration

OIDC Federation

RBAC Assignments
```

Implementation progresses according to:

```text
Phase-0_Roadmap.md
```

---

# Final Outcome

When completed, this repository will provide:

```text
OIDC Authentication

GitHub Actions CI/CD

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

All infrastructure will be fully automated, fully documented, and deployable through GitHub Actions without manual deployment activities.