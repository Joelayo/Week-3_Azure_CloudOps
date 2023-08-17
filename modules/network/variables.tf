# Define variables for the Azure Resource Group, VNet, and subnets.
variable "resource_group_name" {
    description = "Name of the Azure Resource Group."
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

# Define the Azure region for resources.
variable "location" {
    description = "Azure Region for resources."
}
