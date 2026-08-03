packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], lower(var.environment))
    error_message = "Environment must be one of: dev, test, prod."
  }
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "image_version" {
  type    = string
  default = "1.0.0"
}

variable "winrm_username" {
  type    = string
  default = "packer"
}

variable "fslogix_package_url" {
  type      = string
  sensitive = true
}

variable "ama_package_url" {
  type      = string
  sensitive = true
}

variable "gallery_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

locals {
  prefix      = "AK"
  workload    = "AVD"
  environment = upper(var.environment)

  image_resource_group_name = "${local.prefix}-${local.workload}-${local.environment}-IMG-RG"
  gallery_name              = "${local.prefix}-${local.workload}-${local.environment}-ACG"
  image_definition_name     = "AK-WIN11-MS"

  build_vm_name  = "${local.prefix}-${local.workload}-${local.environment}-IMG-BUILD"
  build_nic_name = "${local.prefix}-${local.workload}-${local.environment}-IMG-NIC"

  common_tags = {
    Project     = "Azure Virtual Desktop"
    Environment = lower(var.environment)
    Owner       = "Ayush Kumar"
    ManagedBy   = "Packer"
  }
}

source "azure-arm" "avd_golden_image" {
  use_azure_cli_auth = true

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsDesktop"
  image_offer     = "office-365"
  image_sku       = "win11-24h2-avd-m365"
  image_version   = "latest"

  location                  = var.location
  vm_size                   = var.vm_size
  build_resource_group_name = local.image_resource_group_name

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "30m"
  winrm_username = var.winrm_username

  temp_compute_name = local.build_vm_name
  temp_nic_name     = local.build_nic_name

  shared_image_gallery_destination {
    subscription         = var.subscription_id
    resource_group       = local.image_resource_group_name
    gallery_name         = local.gallery_name
    image_name           = local.image_definition_name
    image_version        = var.image_version
    storage_account_type = var.gallery_storage_account_type

    target_region {
      name = var.location
    }
  }

  shared_image_gallery_timeout = "90m"

  azure_tags = local.common_tags
}

build {
  name    = "avd-golden-image"
  sources = ["source.azure-arm.avd_golden_image"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"

    extra_arguments = [
      "-e", "ansible_connection=winrm",
      "-e", "ansible_winrm_transport=ntlm",
      "-e", "ansible_winrm_server_cert_validation=ignore",
      "-e", "ansible_shell_type=powershell",
      "-e", "fslogix_package_url=${var.fslogix_package_url}",
      "-e", "ama_package_url=${var.ama_package_url}"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Write-Host 'Waiting for Windows Azure Guest Agent service...'",
      "while ((Get-Service WindowsAzureGuestAgent -ErrorAction SilentlyContinue).Status -ne 'Running') { Start-Sleep -Seconds 10 }",

      "Write-Host 'Waiting for RdAgent service...'",
      "while ((Get-Service RdAgent -ErrorAction SilentlyContinue).Status -ne 'Running') { Start-Sleep -Seconds 10 }",

      "Write-Host 'Running Sysprep...'",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",

      "Write-Host 'Waiting for Sysprep generalization state...'",
      "while ($true) {",
      "  $imageState = Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State' | Select-Object -ExpandProperty ImageState",
      "  Write-Host \"Current image state: $imageState\"",
      "  if ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }",
      "  Start-Sleep -Seconds 10",
      "}"
    ]
  }
}