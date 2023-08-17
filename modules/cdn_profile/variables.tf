# This file contains the variables used in the cdn_profile module.
# These variables are used to configure the Azure CDN profile and endpoint resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "cdn_profile_name" {
  description = "Name of the CDN Profile."
}

variable "cdn_endpoint_name" {
  description = "Name of the CDN endpoint."
}

variable "location" {
  description = "Azure region"
}

variable "app_gateway_public_ip_address" {
  description = "Public IP address of the application gateway"
}