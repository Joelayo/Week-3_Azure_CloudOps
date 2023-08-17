# Outputs the ID of the network interface
output "nic_id" {
        value = azurerm_network_interface.jumpbox_nic.id
}