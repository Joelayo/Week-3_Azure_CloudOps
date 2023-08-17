/*
Creates an Azure Resource Group with the specified name and location.

Inputs:
- resource_group_name: The name of the resource group.
- location: The location where the resource group will be created.

Outputs:
- name: The name of the created resource group.
*/

resource "azurerm_resource_group" "main" {
    name     = var.resource_group_name
    location = var.location
}
