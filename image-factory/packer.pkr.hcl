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

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "test", "prod"], lower(var.environment))
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "image_version" {
  type = string
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

locals {
  prefix      = "AK"
  workload    = "AVD"
  environment = upper(var.environment)

  gallery_resource_group_name = "${local.prefix}-${local.workload}-${local.environment}-IMG-RG"

  gallery_name          = "${local.prefix}_${local.workload}_${local.environment}_ACG"
  image_definition_name = "AK-WIN11-MS"

  common_tags = {
    Project     = "Azure Virtual Desktop"
    Environment = local.environment
    Owner       = "Ayush Kumar"
    ManagedBy   = "Packer"
  }
}

source "azure-arm" "avd_golden_image" {

  use_azure_cli_auth = true

  location = var.location

  os_type = "Windows"

  image_publisher = "MicrosoftWindowsDesktop"
  image_offer     = "office-365"
  image_sku       = "win11-24h2-avd-m365"
  image_version   = "latest"

  vm_size = var.vm_size

  communicator = "winrm"

  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "30m"
  winrm_username = var.winrm_username

  shared_image_gallery_destination {

    resource_group = local.gallery_resource_group_name
    gallery_name   = local.gallery_name

    image_name    = local.image_definition_name
    image_version = var.image_version

    storage_account_type = "Standard_LRS"

    target_region {
      name = var.location
    }
  }

  shared_image_gallery_timeout = "90m"

  azure_tags = local.common_tags
}

build {

  name = "avd-golden-image"

  sources = [
    "source.azure-arm.avd_golden_image"
  ]

  provisioner "ansible" {

    use_proxy = false
    user = var.winrm_username

    playbook_file = "./ansible/playbook.yml"

    extra_arguments = [
#      "-e", "ansible_connection=winrm",
      "-e", "ansible_winrm_transport=ntlm",
      "-e", "ansible_winrm_server_cert_validation=ignore",
      "-e", "ansible_shell_type=cmd",
      "-e", "ansible_winrm_operation_timeout_sec=60",
      "-e", "ansible_winrm_read_timeout_sec=90",
      "-e", "fslogix_package_url=${var.fslogix_package_url}",
      "-e", "ama_package_url=${var.ama_package_url}"
    ]
  }

  provisioner "powershell" {

    inline = [

      "while ((Get-Service WindowsAzureGuestAgent -ErrorAction SilentlyContinue).Status -ne 'Running') { Start-Sleep -Seconds 10 }",

      "while ((Get-Service RdAgent -ErrorAction SilentlyContinue).Status -ne 'Running') { Start-Sleep -Seconds 10 }",

      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",

      "while ($true) {",

      "$imageState = Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State' | Select-Object -ExpandProperty ImageState",

      "if ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }",

      "Start-Sleep -Seconds 10",

      "}"
    ]
  }
}