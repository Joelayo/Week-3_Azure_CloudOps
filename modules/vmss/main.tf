/*
 * This resource block creates a Linux virtual machine scale set in Azure.
 * A virtual machine scale set allows you to deploy and manage a set of identical VMs as a single resource.
 * This resource block creates a scale set with 2 instances, using the Standard_Ds1_v2 SKU.
 * The VMs are based on the Canonical Ubuntu Server 22.04 LTS image.
 * The VMs are associated with a network interface that is connected to a specified subnet.
 */

resource "azurerm_linux_virtual_machine_scale_set" "web_tier-vmss" {
    name                = var.vmss_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku                 = "Standard_Ds1_v2"
    instances           = 2
    admin_username      = var.admin_username
    computer_name_prefix = var.vmss_name
    upgrade_mode        = "Automatic"

    admin_ssh_key {
        username   = var.admin_username
        public_key = file("~/.ssh/host_key.pub")
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
    }

    os_disk {
        storage_account_type = "Standard_LRS"
        caching              = "ReadWrite"
    }

    network_interface {
        name    = "${var.vmss_name}-nic"
        primary = true

        ip_configuration {
            name      = "ipconfig1"
            primary   = true
            subnet_id = var.web_tier_subnet_id
            application_gateway_backend_address_pool_ids = var.app_gateway_id
        }
    }

    custom_data = filebase64("./modules/vmss/configure-vmss.sh")
}
