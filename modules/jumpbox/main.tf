/*
Inputs:
- vm_name: The name of the jumpbox virtual machine.
- location: The location where the resources will be created.
- resource_group_name: The name of the resource group where the resources will be created.
- jumpbox_subnet_id: The ID of the subnet where the jumpbox virtual machine will be deployed.
- admin_username: The username for the jumpbox virtual machine.
- ssh_public_key: The public key for SSH access to the jumpbox virtual machine.

Outputs:
- nic_id: The ID of the network interface created for the jumpbox virtual machine.
*/

# Creates a network interface for the jumpbox virtual machine
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_public_ip.id
  }
}

# Creates a public IP address for the jumpbox virtual machine
resource "azurerm_public_ip" "jumpbox_public_ip" {
  name                = "${var.vm_name}-publicip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku              = "Standard"
}

# Creates the jumpbox virtual machine
resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/host_key.pub")
  }

  depends_on = [ 
    azurerm_network_interface.jumpbox_nic, 
    azurerm_public_ip.jumpbox_public_ip
    ]
}
