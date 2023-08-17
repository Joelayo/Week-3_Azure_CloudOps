# This file contains the variables used in the root module.
# These variables are used to configure the Azure resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
}

variable "location" {
  description = "Azure Region for resources."
  default     = "East US"
}

variable "vnet_address_space" {
  description = "CIDR block for the VNet."
}

variable "app_gateway_subnet" {
  description = "CIDR block for the Application Gateway subnet."
}

variable "jumpbox_subnet" {
  description = "CIDR block for the Jumpbox subnet."
}

variable "web_tier_subnet" {
  description = "CIDR block for the Web Tier subnet."
}

variable "database_subnet" {
  description = "CIDR block for the Database subnet."
}

variable "vm_name" {
  description = "Name of the Jumpbox VM."
}

variable "vmss_name" {
  description = "Name of the web tier VMSS"
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway."
}

variable "admin_username" {
  description = "Admin username for the Jumpbox VM."
}

variable "cdn_endpoint_name" {
  description = "Name of the CDN endpoint."
}

variable "cdn_profile_name" {
  description = "Name of the CDN Profile."
}

variable "admin_password" {
  description = "Admin password for the MySQL server"
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
}

variable "private_dns_zone_link_name" {
  description = "Name of the private DNS zone link"
}

variable "database_name" {
  description = "Name of the database"
}

variable "kv_name" {
  description = "Name of the key vault"
}
