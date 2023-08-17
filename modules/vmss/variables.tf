# This file contains the variables used in the VMSS module.
# These variables are used to configure the Azure resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "vmss_name" {
  description = "Name of the web tier VMSS"
}

variable "location" {
  description = "Azure region"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "web_tier_subnet_id" {
  description = "ID of the subnet"
}

variable "admin_username" {
  description = "Admin username for the VMSS"
}

variable "ssh_public_key" {
  description = "SSH public key for authentication"
}

variable "app_gateway_id" {
  description = "ID of the application gateway"
}
