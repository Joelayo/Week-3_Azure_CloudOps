# This file contains the variables used in the application gateway module.
# These variables are used to define the Azure region, resource group name, application gateway name,
# application gateway subnet ID, application gateway public IP ID, user assigned identity ID, and key vault secret identifier.
# Please refer to the description for more information on each variable.

variable "location" {
  description = "Azure region"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway."
}

variable "app_gateway_subnet_id" {
  description = "ID of the application gateway subnet"
}

variable "app_gateway_public_ip" {
  description = "ID of the application gateway public IP"
}

variable "user_assigned_identity_id" {
  description = "ID of the user assigned identity"
}

variable "kv_secret_identifier" {
  description = "Secret identifier for the key vault"
}