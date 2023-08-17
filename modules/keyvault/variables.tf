# This file contains the variables used in the keyvault module.
# These variables are used to configure the Azure resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "location" {
    description = "Azure region"
}

variable "resource_group_name" {
    description = "Name of the resource group"
}

variable "kv_name" {
    description = "Name of the key vault"
}