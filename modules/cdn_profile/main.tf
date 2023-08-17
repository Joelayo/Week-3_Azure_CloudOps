# Creates an Azure CDN profile with the specified name, location, resource group, and SKU.
resource "azurerm_cdn_profile" "web-static" {
    name                = var.cdn_profile_name
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = "Standard_Verizon"
}

# Creates an Azure CDN endpoint with the specified name, profile, location, resource group, and origin.
resource "azurerm_cdn_endpoint" "web-static" {
    name                = var.cdn_endpoint_name
    profile_name        = azurerm_cdn_profile.web-static.name
    location            = var.location
    resource_group_name = var.resource_group_name

    origin {
        name      = "webstatic"
        host_name = var.app_gateway_public_ip_address
        http_port = 80
    }
}