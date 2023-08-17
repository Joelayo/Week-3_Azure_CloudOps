# Creates a private DNS zone for the MySQL flexible server
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

# Links the private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = var.private_dns_zone_link_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name

  depends_on = [ azurerm_private_dns_zone.dns_zone ]
}

# Creates a MySQL flexible server
resource "azurerm_mysql_flexible_server" "mysql_fs" {
  name                   = var.database_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = 7
  delegated_subnet_id    = var.database_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.dns_zone.id
  sku_name               = "GP_Standard_D2ds_v4"
  version                = "8.0.21"

  # Configures high availability for the MySQL flexible server
  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_zone_link]
}