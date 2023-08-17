/*
Inputs:
- vnet_address_space: The address space for the virtual network.
- location: The location where the virtual network will be created.
- resource_group_name: The name of the resource group where the virtual network will be created.
- app_gateway_subnet: The address prefix for the application gateway subnet.
- jumpbox_subnet: The address prefix for the jumpbox subnet.
- web_tier_subnet: The address prefix for the web tier subnet.
- database_subnet: The address prefix for the database subnet.

Outputs:
- vnet_name: The name of the created virtual network.
- jumpbox_subnet_id: The ID of the jumpbox subnet.
*/

# This data source uses an external program to retrieve the public IP address of the machine running Terraform. 
# It runs the script located at "./get_my_ip.sh" and returns the output as a string.
data "external" "my_ip" {
    program = ["./modules/network/get_my_ip.sh"]
}

locals {
    my_ip = tostring(data.external.my_ip.result["my_ip"])
}

# Creates a virtual network resource with the specified name, address space, location, and resource group.
resource "azurerm_virtual_network" "main" {
    name                = "tf-two-tier-vnet"
    address_space       = [var.vnet_address_space]
    location            = var.location
    resource_group_name = var.resource_group_name
}

# Creates a subnet resource for the application gateway with the specified name, resource group, virtual network, and address prefixes.
resource "azurerm_subnet" "app_gateway" {
    name                 = "app-gateway-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.app_gateway_subnet]
}

# Creates a subnet resource for the jumpbox with the specified name, resource group, virtual network, and address prefixes.
resource "azurerm_subnet" "jumpbox" {
    name                 = "jumpbox-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.jumpbox_subnet]
}

# Creates a subnet resource for the web tier with the specified name, resource group, virtual network, and address prefixes.
resource "azurerm_subnet" "web_tier" {
    name                 = "web-tier-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.web_tier_subnet]
}

# Creates a subnet resource for the database with the specified name, resource group, virtual network, and address prefixes.
resource "azurerm_subnet" "database" {
    name                 = "database-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = [var.database_subnet]

    delegation {
    name = "database-delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# NSG rules for jumpbox subnet
resource "azurerm_network_security_group" "jumpbox_nsg" {
    name                = "jumpbox-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = local.my_ip # Use the dynamic IP
        destination_address_prefix = var.jumpbox_subnet
    }
}

# NSG rules for web tier subnet
resource "azurerm_network_security_group" "web_tier_nsg" {
    name                = "web-tier-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowHTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = var.web_tier_subnet
    }
}

# NSG rules for database subnet
resource "azurerm_network_security_group" "database_nsg" {
    name                = "database-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "AllowMySQL"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = var.database_subnet
    }
}

# Attach NSG to subnets
resource "azurerm_subnet_network_security_group_association" "jumpbox_nsg_association" {
    subnet_id                 = azurerm_subnet.jumpbox.id
    network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "web_tier_nsg_association" {
    subnet_id                 = azurerm_subnet.web_tier.id
    network_security_group_id = azurerm_network_security_group.web_tier_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "database_nsg_association" {
    subnet_id                 = azurerm_subnet.database.id
    network_security_group_id = azurerm_network_security_group.database_nsg.id
}
