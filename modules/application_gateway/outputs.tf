# Output for the ID of the public IP address associated with the application gateway
output "app_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway_public_ip.id
}

# Output for the ID of the backend address pool associated with the application gateway
output "app_gateway_id" {
  value = azurerm_application_gateway.network.backend_address_pool[*].id
}

# Output for the public IP address associated with the application gateway
output "app_gateway_public_ip_address" {
  value = azurerm_public_ip.app_gateway_public_ip.ip_address
}