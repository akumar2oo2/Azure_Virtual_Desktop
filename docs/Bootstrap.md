# Phase 1 - Manual Bootstrap And OIDC Validation

# 1. Purpose

Phase 1 establishes the secure deployment foundation for the Azure Virtual Desktop Enterprise Platform.

This phase covers:

```text
Phase 1A - Manual Bootstrap

Phase 1B - OIDC Validation
```

Phase 1A creates the required Azure foundation manually because Terraform authentication does not exist yet.

Phase 1B validates that GitHub Actions can authenticate to Azure using OIDC and initialize Terraform with remote state.

Terraform implementation begins only after Phase 1A and Phase 1B are complete.

---

# 2. Phase 1 Design

The platform uses a single deployment identity and a single federated credential.

## Deployment Identity

```text
AK-SPN-AVD
```

## Federated Credential

```text
AK-GitHub-OIDC
```

## Terraform Backend

```text
AK-RG-TFSTATE

akavdtfstate

tfstate
```

## Authentication Model

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

---

# 3. Phase 1A - Manual Bootstrap

# 3.1 Objective

Create the required Azure bootstrap resources manually before Terraform is introduced.

Terraform does not manage bootstrap resources.

This approach is intentional because OIDC authentication and remote state do not exist before the bootstrap process.

---

# 3.2 Resources Created In Phase 1A

## Resource Group

```text
AK-RG-TFSTATE
```

Purpose:

```text
Stores Terraform backend resources.
```

---

## Storage Account

```text
akavdtfstate
```

Purpose:

```text
Provides remote Terraform state storage.
```

---

## Blob Container

```text
tfstate
```

Purpose:

```text
Stores Terraform state files.
```

Expected future state files:

```text
dev.tfstate

test.tfstate

prod.tfstate
```

---

## App Registration

```text
AK-SPN-AVD
```

Purpose:

```text
Deployment identity used by GitHub Actions.
```

Responsibilities:

```text
Terraform Deployments

Image Factory

Azure Compute Gallery

Azure Virtual Desktop

Monitoring

Future Platform Components
```

---

## Federated Credential

```text
AK-GitHub-OIDC
```

Purpose:

```text
Provides passwordless GitHub Actions authentication to Azure.
```

This single federated credential is shared across:

```text
dev

test

prod
```

Environment selection is handled by GitHub workflow parameters.

---

# 3.3 Step 1 - Create Terraform State Resource Group

## Azure Portal Path

```text
Azure Portal
→ Resource Groups
→ Create
```

## Configuration

### Resource Group Name

```text
AK-RG-TFSTATE
```

### Region

Use the selected platform region.

Example:

```text
Central India
```

---

# 3.4 Step 2 - Create Terraform State Storage Account

## Azure Portal Path

```text
Azure Portal
→ Storage Accounts
→ Create
```

## Configuration

### Resource Group

```text
AK-RG-TFSTATE
```

### Storage Account Name

```text
akavdtfstate
```

### Performance

```text
Standard
```

### Redundancy

```text
Locally Redundant Storage
```

### Account Kind

```text
StorageV2
```

### Public Network Access

For initial setup:

```text
Enabled
```

This can be restricted later after the deployment model is fully validated.

---

# 3.5 Step 3 - Create Terraform State Blob Container

## Azure Portal Path

```text
Azure Portal
→ Storage Accounts
→ akavdtfstate
→ Data Storage
→ Containers
→ Create
```

## Configuration

### Container Name

```text
tfstate
```

### Public Access Level

```text
Private
```

---

# 3.6 Step 4 - Create App Registration

## Azure Portal Path

```text
Azure Portal
→ Microsoft Entra ID
→ App Registrations
→ New Registration
```

## Configuration

### Name

```text
AK-SPN-AVD
```

### Supported Account Types

Select:

```text
Accounts in this organizational directory only
```

### Microsoft Entra ID Portal Wording Reference

| New Portal Wording | Previous Portal Wording |
|----------|----------|
| Single tenant - Default Directory | Accounts in this organizational directory only |
| Multiple Entra ID tenants | Accounts in any organizational directory |
| Any Entra ID Tenant + Personal Microsoft accounts | Accounts in any organizational directory and personal Microsoft accounts |
| Personal accounts only | Personal Microsoft accounts only |

### Selected Option

```text
Single tenant - Default Directory
```

Reason:

```text
The Azure Virtual Desktop platform is deployed into a single Microsoft Entra ID tenant and a single Azure subscription.

A single deployment identity is used:

AK-SPN-AVD

A single federated credential is used:

AK-GitHub-OIDC

Multi-tenant support is not required.
```

### Redirect URI

```text
Not Required
```

---

# 3.7 Step 5 - Create Federated Credential

## Azure Portal Path

```text
Azure Portal
→ Microsoft Entra ID
→ App Registrations
→ AK-SPN-AVD
→ Certificates & Secrets
→ Federated Credentials
→ Add Credential
```

## Configuration

### Federated Credential Scenario

```text
GitHub Actions Deploying Azure Resources
```

### Name

```text
AK-GitHub-OIDC
```

### Description

```text
Allows GitHub Actions workflows in Azure_Virtual_Desktop repository to authenticate to Azure using OIDC without client secrets.
```

---

### GitHub Organization

Specify the GitHub account that owns the repository.

Example:

```text
akumar2oo2
```

---

### GitHub Organization ID

The Microsoft Entra portal requires the numeric GitHub account ID.

To obtain the Organization/User ID:

```text
https://api.github.com/users/<github_username>
```

Example:

```text
https://api.github.com/users/akumar2oo2
```

Locate the following field:

```json
"id": 123456789
```

Use the numeric value as the:

```text
Organization ID
```

---

### Repository

Specify the repository name.

Example:

```text
Azure_Virtual_Desktop
```

The repository must already exist before creating the federated credential.

---

### Repository ID

The Microsoft Entra portal requires the numeric GitHub repository ID.

To obtain the Repository ID:

```text
https://api.github.com/repos/<github_username>/<repository_name>
```

Example:

```text
https://api.github.com/repos/akumar2oo2/Azure_Virtual_Desktop
```

Locate the following field:

```json
"id": 987654321
```

Use the numeric value as the:

```text
Repository ID
```

---

### Entity Type

Select:

```text
Branch
```

---

### GitHub Branch Name

```text
main
```

---

### Subject Identifier

This value is automatically generated by Microsoft Entra ID.

Example:

```text
repo:akumar2oo2@<Organization ID>/Azure_Virtual_Desktop@<Repository ID>:ref:refs/heads/main
```

No manual modification is required.

---

## Purpose

This federated credential establishes trust between:

```text
GitHub Actions
```

and:

```text
AK-SPN-AVD
```

allowing GitHub to authenticate to Azure without client secrets.

This means GitHub Actions from the main branch can request an OIDC token for the Azure App Registration.

---

## Validation

Verify all of the following before saving:

```text
Organization is correct

Organization ID is correct

Repository is correct

Repository ID is correct

Entity Type = Branch

Branch Name = main
```

After saving, the federated credential should appear as:

```text
AK-GitHub-OIDC
```

under:

```text
AK-SPN-AVD
→ Certificates & Secrets
→ Federated Credentials
```

---

# 3.8 Step 6 - Assign Subscription RBAC

## Azure Portal Path

```text
Azure Portal
→ Subscriptions
→ <Subscription Name>
→ Access Control (IAM)
→ Add Role Assignment
```

## Role

```text
Contributor
```

## Principal

```text
AK-SPN-AVD
```

## Purpose

Allows Terraform to create, update, and delete Azure resources in the subscription.

---

# 3.9 Step 7 - Assign Terraform Backend RBAC

## Azure Portal Path

```text
Azure Portal
→ Storage Accounts
→ akavdtfstate
→ Access Control (IAM)
→ Add Role Assignment
```

## Role

```text
Storage Blob Data Contributor
```

## Principal

```text
AK-SPN-AVD
```

## Purpose

Allows Terraform to read, write, update, and lock state files inside the Terraform backend container.

---

# 3.10 Phase 1A Validation Checklist

Before moving to Phase 1B, verify the following.

## Azure Resources

```text
AK-RG-TFSTATE exists

akavdtfstate exists

tfstate container exists
```

## Identity Resources

```text
AK-SPN-AVD exists

AK-GitHub-OIDC exists
```

## RBAC

```text
AK-SPN-AVD has Contributor on the subscription

AK-SPN-AVD has Storage Blob Data Contributor on akavdtfstate
```

## Repository

```text
Azure_Virtual_Desktop repository exists

main branch exists
```

---

# 3.11 Phase 1A Exit Criteria

Phase 1A is complete when:

```text
Terraform backend resources exist

Azure deployment identity exists

OIDC federated credential exists

Required RBAC assignments exist

GitHub repository is ready
```

No Terraform resources are deployed during Phase 1A.

---

# 4. Phase 1B - OIDC Validation

# 4.1 Objective

Validate that GitHub Actions can authenticate to Azure using OIDC and initialize Terraform using the manually created backend.

Phase 1B proves that the platform can move from manual bootstrap to automated deployment.

---

# 4.2 Phase 1B Deliverables

Phase 1B creates the initial repository files required to validate authentication and Terraform initialization.

## Required Files

```text
.github/workflows/terraform-plan.yml

versions.tf

providers.tf

main.tf

variables.tf

outputs.tf
```

At this stage, Terraform does not need to deploy production resources.

The goal is only to validate:

```text
Azure login

Terraform initialization

Terraform validation

Terraform plan
```

---

# 4.3 Required GitHub Repository Secrets

The workflow should use GitHub repository secrets for Azure authentication configuration.

## Required Secrets

```text
AZURE_CLIENT_ID

AZURE_TENANT_ID

AZURE_SUBSCRIPTION_ID
```

These values identify:

```text
App Registration Client ID

Tenant ID

Subscription ID
```

No client secret is required.

Authentication is performed using:

```text
AK-GitHub-OIDC

AK-SPN-AVD
```

through OIDC federation.

---

## GitHub Repository Path

```text
GitHub Repository
→ Settings
→ Secrets And Variables
→ Actions
→ Secrets
```

Create the following repository secrets:

```text
AZURE_CLIENT_ID

AZURE_TENANT_ID

AZURE_SUBSCRIPTION_ID
```

---

# 4.4 GitHub Workflow Permission Requirements

The GitHub workflow must include:

```yaml
permissions:
  id-token: write
  contents: read
```

## Purpose

```text
id-token: write
```

allows GitHub Actions to request an OIDC token.

```text
contents: read
```

allows the workflow to read repository files.

---

# 4.5 Terraform Backend Configuration

Terraform must use the manually created backend.

## Backend Design

```text
Resource Group: AK-RG-TFSTATE

Storage Account: akavdtfstate

Container: tfstate
```

## State File Pattern

```text
<environment>.tfstate
```

Examples:

```text
dev.tfstate

test.tfstate

prod.tfstate
```

---

# 4.6 Environment Selection Strategy

The same workflow supports multiple environments.

## Supported Environments

```text
dev

test

prod
```

The selected environment controls:

```text
Terraform state file

Terraform variable file

Resource naming

Deployment scope
```

Authentication remains the same for all environments:

```text
AK-SPN-AVD

AK-GitHub-OIDC
```

## Example Workflow Execution

When manually running the workflow:

```text
GitHub
→ Actions
→ Terraform Apply
→ Run Workflow
```

GitHub will prompt for an environment selection.

Example:

```text
Environment

▼ dev
  test
  prod
```

If:

```text
dev
```

is selected, Terraform will use:

```text
environments/dev.tfvars

dev.tfstate
```

If:

```text
test
```

is selected, Terraform will use:

```text
environments/test.tfvars

test.tfstate
```

If:

```text
prod
```

is selected, Terraform will use:

```text
environments/prod.tfvars

prod.tfstate
```

The selected environment determines:

```text
Terraform variable file

Terraform state file

Resource naming

Deployment scope
```

Authentication remains unchanged and always uses:

```text
AK-SPN-AVD

AK-GitHub-OIDC
```

for all environments.

### Example GitHub Workflow Input

```yaml
workflow_dispatch:
  inputs:
    environment:
      description: Environment to deploy
      required: true
      type: choice
      options:
        - dev
        - test
        - prod
```

---

# 4.7 Initial Terraform Validation Goal

The first Terraform validation should confirm that the repository structure and backend are working.

The first plan may contain no real resources.

That is acceptable for Phase 1B.

Phase 1B is about validating the foundation before platform resources are introduced.

---

# 4.8 Expected OIDC Validation Flow

```text
GitHub Workflow Triggered

      │

      ▼

Environment Selected

      │

      ▼

GitHub Requests OIDC Token

      │

      ▼

Azure App Registration Trusts Token

      │

      ▼

Azure Login Successful

      │

      ▼

Terraform Init Successful

      │

      ▼

Terraform Validate Successful

      │

      ▼

Terraform Plan Successful
```

---

# 4.9 Phase 1B Validation Checklist

Verify the following from the GitHub Actions workflow logs.

## Azure Login

```text
Azure login completed successfully
```

## Terraform Init

```text
Terraform backend initialized successfully
```

## Terraform Validate

```text
Terraform configuration is valid
```

## Terraform Plan

```text
Terraform plan completed successfully
```

---

# 4.10 Phase 1B Exit Criteria

Phase 1B is complete when:

```text
GitHub Actions authenticates to Azure using OIDC

No client secret is used

Terraform initializes remote backend successfully

Terraform validates successfully

Terraform plan runs successfully
```

After Phase 1B is complete, the project can move to:

```text
Phase 2 - Repository Framework
```

---

# 5. Security Standards

## Allowed

```text
OIDC

Federated Credential

GitHub Repository Variables

Azure RBAC
```

## Prohibited

```text
Client Secrets

Username And Password Authentication

Personal Access Token For Azure Authentication

Hardcoded Credentials
```

---

# 6. Troubleshooting

## Issue 1 - Azure Login Fails

Check:

```text
Federated credential repository name

Federated credential branch name

AZURE_CLIENT_ID

AZURE_TENANT_ID

AZURE_SUBSCRIPTION_ID

Workflow permissions
```

---

## Issue 2 - Terraform Init Fails

Check:

```text
Storage Account Name

Container Name

Resource Group Name

Storage Blob Data Contributor Assignment

Backend Configuration
```

---

## Issue 3 - Authorization Fails During Terraform Plan

Check:

```text
Contributor Role Assignment

Subscription Scope

App Registration Service Principal
```

---

# 7. Phase 1 Completion Summary

Phase 1 is complete when both Phase 1A and Phase 1B are complete.

## Phase 1A Completion

```text
Manual Azure Bootstrap Completed
```

## Phase 1B Completion

```text
OIDC Authentication Validated
```

## Final Phase 1 Outcome

```text
Remote Terraform State Ready

GitHub OIDC Authentication Ready

Deployment Identity Ready

Terraform Workflow Ready

Platform Ready For Modular Infrastructure Deployment
```