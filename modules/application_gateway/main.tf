/* 
  This Terraform module creates an Azure Application Gateway with a public IP address, 
  a backend address pool, an HTTP listener, and a request routing rule. 

  The module takes the following input variables:
  - app_gateway_name: The name of the application gateway to create.
  - resource_group_name: The name of the resource group in which to create the application gateway.
  - location: The Azure region in which to create the application gateway.
  - app_gateway_subnet_id: The ID of the subnet in which to deploy the application gateway.

  The module creates the following resources:
  - azurerm_public_ip.app_gateway_public_ip: A public IP address for the application gateway.
  - azurerm_application_gateway.network: The application gateway itself, with a backend address pool, 
    an HTTP listener, and a request routing rule.
*/

resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.app_gateway_name}-publicip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Defines local variables for re-used values
locals {
  backend_address_pool_name      = "${var.app_gateway_name}-beap"
  frontend_port_name             = "${var.app_gateway_name}-feport"
  frontend_ip_configuration_name = "${var.app_gateway_name}-feip"
  http_setting_name              = "${var.app_gateway_name}-be-htst"
  listener_name                  = "${var.app_gateway_name}-httplstn"
  request_routing_rule_name      = "${var.app_gateway_name}-rqrt"
  redirect_configuration_name    = "${var.app_gateway_name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.app_gateway_name}-ipconfig"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name = "app_listener"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  ssl_certificate {
    name = "app_listener"
    key_vault_secret_id = var.kv_secret_identifier
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 100
  }

  depends_on = [ 
    azurerm_public_ip.app_gateway_public_ip
    ]
}