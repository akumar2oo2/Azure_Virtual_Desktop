# Phase 8 - Monitoring Platform

# 1. Purpose

Phase 8 introduces the monitoring foundation for the Azure Virtual Desktop platform.

The purpose of this phase is to establish centralized monitoring resources that will be consumed by future Session Hosts, Azure Virtual Desktop components, FSLogix infrastructure, and platform services.

Monitoring is implemented before Session Hosts in alignment with:

```text
Architecture Principle 4

Monitoring By Design
```

The monitoring platform is fully environment-driven and all monitoring behavior is controlled through tfvars files.

No monitoring configuration is hardcoded within Terraform modules.

---

# 2. Scope

The following items are implemented during Phase 8:

```text
Monitoring Resource Group

Log Analytics Workspace

Data Collection Rules

Action Groups

Workbooks

Monitoring Terraform Module

Monitoring Configuration Framework
```

The following items are not implemented during Phase 8:

```text
Session Host Monitoring Associations

Azure Monitor Agent Deployment

Data Collection Rule Associations

AVD Diagnostic Settings

FSLogix Diagnostic Settings

Session Host Alerting

Production Monitoring Rules

Custom Workbooks
```

These capabilities are implemented during future phases.

---

# 3. Repository Structure

Phase 8 introduces the Monitoring module.

```text
Azure_Virtual_Desktop/
│
├── modules/
│   └── monitoring/
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

# 4. Monitoring Architecture

The monitoring platform provides centralized observability for all future Azure Virtual Desktop workloads.

The monitoring architecture consists of:

```text
Log Analytics Workspace

Data Collection Rules

Workbooks

Action Groups

Alerts
```

Multiple monitoring objects can exist within a single environment.

All monitoring resources are deployed from tfvars-driven configuration.

---

## Architecture Flow

```text
Azure Resources

      │

      ▼

Azure Monitor Agent

      │

      ▼

Data Collection Rules

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

# 5. Monitoring Resource Group Strategy

Each environment receives a dedicated Monitoring Resource Group.

---

## Naming Pattern

```text
AK-AVD-<ENV>-MON-RG
```

---

## Examples

```text
AK-AVD-DEV-MON-RG

AK-AVD-TEST-MON-RG

AK-AVD-PROD-MON-RG
```

---

## Purpose

The Monitoring Resource Group stores:

```text
Log Analytics Workspace

Data Collection Rules

Workbooks

Action Groups

Alerts

Future Monitoring Resources
```

---

# 6. Log Analytics Workspace Strategy

Each environment deploys a single Log Analytics Workspace.

---

## Naming Pattern

```text
AK-AVD-<ENV>-LAW
```

---

## Examples

```text
AK-AVD-DEV-LAW

AK-AVD-TEST-LAW

AK-AVD-PROD-LAW
```

---

## Design Principles

```text
Single Workspace Per Environment

Centralized Log Storage

Environment Isolation

Reusable Monitoring Foundation
```

---

# 7. Data Collection Rule Strategy

The platform supports multiple Data Collection Rules per environment.

Data Collection Rules are fully environment-driven.

---

## Naming Pattern

```text
AK-AVD-<ENV>-DCR-<NAME>
```

---

## Examples

```text
AK-AVD-DEV-DCR-SESSIONHOSTS

AK-AVD-DEV-DCR-FSLOGIX

AK-AVD-DEV-DCR-PLATFORM
```

---

## Purpose

Multiple Data Collection Rules allow different workloads to collect different telemetry.

Examples:

```text
Session Hosts

FSLogix

Platform Services

Future Workloads
```

---

# 8. Workbook Strategy

The platform supports multiple Workbooks per environment.

---

## Naming Pattern

```text
AK-AVD-<ENV>-WB-<NAME>
```

---

## Examples

```text
AK-AVD-DEV-WB-AVD

AK-AVD-DEV-WB-SESSIONHOSTS

AK-AVD-DEV-WB-FSLOGIX
```

---

## Purpose

Provide visualization and operational dashboards for:

```text
AVD

Session Hosts

FSLogix

Future Platform Components
```

---

# 9. Action Group Strategy

The platform supports multiple Action Groups per environment.

---

## Naming Pattern

```text
AK-AVD-<ENV>-AG-<NAME>
```

---

## Examples

```text
AK-AVD-DEV-AG-OPERATIONS

AK-AVD-DEV-AG-PLATFORM
```

---

## Purpose

Notify operations teams when alerts are triggered.

---

# 10. Alert Strategy

The platform supports multiple alert definitions.

---

## Naming Pattern

```text
AK-AVD-<ENV>-ALERT-<NAME>
```

---

## Examples

```text
AK-AVD-DEV-ALERT-CPU

AK-AVD-DEV-ALERT-MEMORY

AK-AVD-DEV-ALERT-HEARTBEAT

AK-AVD-DEV-ALERT-FSLOGIX
```

---

# 11. Monitoring Object Design

The monitoring platform is fully object-driven.

All monitoring behavior is controlled through tfvars.

---

## Monitoring Object Example

```hcl
monitoring = {
  enabled = true

  law = {
    enabled          = true
    retention_days   = 30
    daily_quota_gb   = -1
    sku              = "PerGB2018"
  }

  dcrs = {
    sessionhosts = {
      enabled = true
    }

    fslogix = {
      enabled = true
    }

    platform = {
      enabled = true
    }
  }

  workbooks = {
    avd = {
      enabled = true
    }

    sessionhosts = {
      enabled = true
    }

    fslogix = {
      enabled = false
    }
  }

  alerts = {
    cpu = {
      enabled = true
      threshold = 80
    }

    memory = {
      enabled = true
      threshold = 85
    }

    heartbeat = {
      enabled = true
    }
  }
}
```

---

# 12. Log Analytics Workspace Object

Required Properties:

```text
enabled

retention_days

daily_quota_gb

sku
```

---

## Example

```hcl
law = {
  enabled          = true
  retention_days   = 30
  daily_quota_gb   = -1
  sku              = "PerGB2018"
}
```

---

# 13. Data Collection Rule Object

Each DCR is represented as an object.

---

## Example

```hcl
sessionhosts = {
  enabled = true

  description = "AVD Session Host Monitoring"

  windows_event_logs = [
    "Application",
    "System"
  ]

  performance_counters = [
    "\\Processor(_Total)\\% Processor Time",
    "\\Memory\\% Committed Bytes In Use"
  ]

  sampling_frequency_seconds = 60
}
```

---

## Future Use Cases

```text
Session Hosts

FSLogix

Platform Monitoring

Security Monitoring
```

---

# 14. Workbook Object

Each Workbook is represented as an object.

---

## Example

```hcl
avd = {
  enabled = true

  display_name = "Azure Virtual Desktop Overview"
}
```

---

# 15. Alert Object Design

Each alert is represented as an object.

---

## CPU Alert Example

```hcl
cpu = {
  enabled = true

  severity  = 2
  threshold = 80

  evaluation_frequency = "PT5M"
  window_size          = "PT15M"

  action_group = "operations"
}
```

---

## Memory Alert Example

```hcl
memory = {
  enabled = true

  severity  = 2
  threshold = 85

  evaluation_frequency = "PT5M"
  window_size          = "PT15M"

  action_group = "operations"
}
```

---

## Heartbeat Alert Example

```hcl
heartbeat = {
  enabled = true

  severity = 1

  evaluation_frequency = "PT5M"
  window_size          = "PT15M"

  action_group = "operations"
}
```

---

# 16. Azure Monitor Agent Strategy

Azure Monitor Agent is intentionally excluded from Golden Images.

Azure Monitor Agent is deployed using VM Extensions.

Phase 8 documents the monitoring design but does not deploy Azure Monitor Agent.

Reason:

```text
No Session Hosts Exist
```

Azure Monitor Agent deployment occurs during:

```text
Phase 9 - Session Hosts
```

---

# 17. Monitoring Module

## Module

```text
modules/monitoring
```

---

## Purpose

Creates monitoring resources required by the platform.

---

## Resources

```text
Log Analytics Workspace

Data Collection Rules

Action Groups

Workbooks
```

---

## Inputs

```text
monitoring

resource_group_name

location

tags
```

---

## Outputs

```text
law_id

law_name

dcr_ids

dcr_names

workbook_ids

workbook_names

action_group_ids

action_group_names
```

---

# 18. Deployment Flow

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

Monitoring Module

      │

      ▼

Log Analytics Workspace

      │

      ▼

Data Collection Rules

      │

      ▼

Action Groups

      │

      ▼

Workbooks

      │

      ▼

Monitoring Foundation
```

---

# 19. Validation Checklist

Verify:

```text
Monitoring Resource Group Created

Log Analytics Workspace Created

Data Collection Rules Created

Action Groups Created

Workbooks Created

Terraform Validate Successful

Terraform Plan Successful

Terraform Apply Successful

Outputs Verified
```

---

# 20. Exit Criteria

Phase 8 is complete when:

```text
Monitoring Resource Group Created

Log Analytics Workspace Created

Multiple DCRs Supported

Multiple Workbooks Supported

Multiple Alert Definitions Supported

Environment Driven Monitoring Working

No Hardcoded Monitoring Values

Outputs Verified
```

The platform is now prepared for Session Host monitoring.

---

# 21. Next Phase

Upon completion of Phase 8 the project moves to:

```text
Phase 9 - Session Hosts
```

Phase 9 introduces:

```text
Session Host Virtual Machines

Azure Monitor Agent VM Extension

DCR Associations

FSLogix Integration

Host Pool Registration

Session Host Scaling Foundations
```

Phase 9 is the first phase that deploys user-facing compute resources.