# Test Environment Configuration
# Used when the GitHub Actions workflow is executed with:
# environment = test
#
# This file contains environment-specific values that Terraform
# uses during planning and deployment.

environment = "test"

# Standard resource naming prefix.
project_prefix = "AK"

# Azure Virtual Desktop project name.
project_name = "AVD"

# Primary Azure region for test resources.
location = "centralindia"