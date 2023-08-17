# This file contains the variables used in the Azure Resource Group module.
# These variables are used to configure the Azure resources created by the module.
# Please refer to the description of each variable for more information on their usage.

variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
}

variable "location" {
    description = "Azure Region for resources."
}