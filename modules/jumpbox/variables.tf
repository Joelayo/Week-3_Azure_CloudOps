# This file contains the variables used in the jumpbox module.
# These variables are used to configure the Azure resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "vm_name" {
  description = "Name of the virtual machine"
}

variable "location" {
  description = "Azure region"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "network_interface_id" {
  description = "ID of the network interface to attach to the VM"
}

variable "admin_username" {
  description = "Admin username for the VM"
}

variable "ssh_public_key" {
  description = "SSH public key for authentication"
}

variable "jumpbox_subnet_id" {
  description = "ID of the jumpbox subnet"
}
