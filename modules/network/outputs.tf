output "vnet_name" {
        value = azurerm_virtual_network.main.name
}

output "jumpbox_subnet_id" {
        value = azurerm_subnet.jumpbox.id
}

output "web_tier_subnet_id" {
        value = azurerm_subnet.web_tier.id
}

output "app_gateway_subnet_id" {
        value = azurerm_subnet.app_gateway.id
}

output "database_subnet_id" {
        value = azurerm_subnet.database.id
}

output "virtual_network_id" {
        value = azurerm_virtual_network.main.id
}