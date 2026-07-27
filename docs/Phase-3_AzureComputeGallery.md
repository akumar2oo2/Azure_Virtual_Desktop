# Phase 3 - Azure Compute Gallery Foundation

# 1. Purpose

Phase 3 establishes the image infrastructure for the Azure Virtual Desktop platform.

This is the first phase that deploys Azure resources.

The objective is to create Azure Compute Galleries and Image Definitions that will be used by the Image Factory in Phase 4 and Session Hosts in Phase 9.

No images are built during this phase.

This phase only creates the image platform foundation.

---

# 2. Scope

The following items are implemented during Phase 3:

```text
Azure Compute Gallery

Image Definition

Image Versioning Strategy

Terraform Image Gallery Module
```

The following items are not implemented during Phase 3:

```text
Golden Images

Packer Builds

Ansible Configuration

Session Hosts

Azure Virtual Desktop
```

These components are delivered in later phases.

---

# 3. Resource Group Strategy

The platform uses separate resource groups for each workload and environment.

---

## DEV

```text
AK-AVD-DEV-NET-RG

AK-AVD-DEV-IMG-RG

AK-AVD-DEV-ID-RG

AK-AVD-DEV-AVD-RG

AK-AVD-DEV-MON-RG

AK-AVD-DEV-FSL-RG
```

---

## TEST

```text
AK-AVD-TEST-NET-RG

AK-AVD-TEST-IMG-RG

AK-AVD-TEST-ID-RG

AK-AVD-TEST-AVD-RG

AK-AVD-TEST-MON-RG

AK-AVD-TEST-FSL-RG
```

---

## PROD

```text
AK-AVD-PROD-NET-RG

AK-AVD-PROD-IMG-RG

AK-AVD-PROD-ID-RG

AK-AVD-PROD-AVD-RG

AK-AVD-PROD-MON-RG

AK-AVD-PROD-FSL-RG
```

---

# 4. Azure Compute Gallery Strategy

The platform uses one Azure Compute Gallery per environment.

This keeps image lifecycles isolated between environments.

---

## DEV Gallery

```text
AK-AVD-DEV-ACG
```

Resource Group:

```text
AK-AVD-DEV-IMG-RG
```

---

## TEST Gallery

```text
AK-AVD-TEST-ACG
```

Resource Group:

```text
AK-AVD-TEST-IMG-RG
```

---

## PROD Gallery

```text
AK-AVD-PROD-ACG
```

Resource Group:

```text
AK-AVD-PROD-IMG-RG
```

---

# 5. Image Definition Strategy

Phase 3 creates the image definitions that future image versions will be published to.

---

## Image Definition

```text
AK-WIN11-MS
```

Meaning:

```text
AK

Windows 11

Multi-Session
```

---

## Operating System

```text
Windows 11 Enterprise Multi-Session
```

---

## Gallery Relationship

```text
AK-AVD-DEV-ACG
    └── AK-WIN11-MS

AK-AVD-TEST-ACG
    └── AK-WIN11-MS

AK-AVD-PROD-ACG
    └── AK-WIN11-MS
```

---

# 6. Image Versioning Strategy

The platform uses Semantic Versioning.

---

## Format

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

Used for:

```text
Operating System Upgrade

Major Architectural Change
```

---

## Minor

Used for:

```text
Application Additions

Feature Enhancements

Configuration Changes
```

---

## Patch

Used for:

```text
Security Updates

Bug Fixes

Maintenance Releases
```

---

# 7. Terraform Module

Phase 3 introduces:

```text
modules/image-gallery/
```

Structure:

```text
modules/image-gallery/

├── versions.tf
├── main.tf
├── variables.tf
└── outputs.tf
```

---

# 8. Module Responsibilities

The Image Gallery module is responsible for:

```text
Azure Compute Gallery Creation

Image Definition Creation

Image Metadata Configuration

Output Values
```

---

# 9. Module Outputs

Expected outputs:

```text
gallery_id

gallery_name

image_definition_id

image_definition_name
```

These outputs will be consumed during:

```text
Phase 4 - Image Factory

Phase 9 - Session Hosts
```

---

# 10. Dependency Flow

Phase 3 creates the foundation used by future phases.

```text
Phase 3
    │
    ▼
Azure Compute Gallery
    │
    ▼
Phase 4
Image Factory
    │
    ▼
Golden Image Versions
    │
    ▼
Phase 9
Session Hosts
```

---

# 11. Validation Checklist

Verify:

```text
AK-AVD-DEV-IMG-RG Exists

AK-AVD-TEST-IMG-RG Exists

AK-AVD-PROD-IMG-RG Exists

AK-AVD-DEV-ACG Exists

AK-AVD-TEST-ACG Exists

AK-AVD-PROD-ACG Exists

AK-WIN11-MS Exists In All Galleries
```

---

# 12. Exit Criteria

Phase 3 is complete when:

```text
Image Gallery Module Created

DEV Gallery Created

TEST Gallery Created

PROD Gallery Created

Image Definitions Created

Versioning Strategy Established
```

No Golden Images are created during this phase.

---

# 13. Next Phase

Upon completion of Phase 3 the project moves to:

```text
Phase 4 - Image Factory
```

Phase 4 introduces:

```text
Packer

Ansible

Golden Image Creation

Azure Compute Gallery Publishing
```