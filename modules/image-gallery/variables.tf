# Inputs for the image-gallery module.

variable "resource_group_name" {
  description = "Resource group that will contain the Azure Compute Gallery"
  type        = string
}

variable "location" {
  description = "Azure region for the gallery and image definition"
  type        = string
}

variable "gallery_name" {
  description = "Name of the Azure Compute Gallery"
  type        = string
}

variable "image_definition_name" {
  description = "Name of the image definition"
  type        = string
}

variable "image_publisher" {
  description = "Publisher identifier stored in the image definition"
  type        = string
}

variable "image_offer" {
  description = "Offer identifier stored in the image definition"
  type        = string
}

variable "image_sku" {
  description = "SKU identifier stored in the image definition"
  type        = string
}

variable "tags" {
  description = "Tags applied to the gallery and image definition"
  type        = map(string)
  default     = {}
}