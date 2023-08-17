/*
  This Terraform configuration file creates an Azure 2-tier infrastructure with the following modules:
  - resource_group: creates a resource group
  - storage_account: creates a storage account and a container
  - network: creates a virtual network with subnets for app gateway, jumpbox, web tier, and database
  - jumpbox: creates a jumpbox virtual machine for remote access to the virtual network
  - vmss: creates a virtual machine scale set for the web tier
  - app_gateway: creates an application gateway for load balancing and SSL termination
  - cdn_profile: creates a CDN profile and endpoint for content delivery

  The configuration file takes in the following variables:
  - resource_group_name: name of the resource group to be created
  - location: location of the Azure region where the resources will be created
  - vnet_address_space: address space of the virtual network
  - app_gateway_subnet: subnet for the application gateway
  - jumpbox_subnet: subnet for the jumpbox
  - web_tier_subnet: subnet for the web tier
  - database_subnet: subnet for the database
  - vm_name: name of the jumpbox virtual machine
  - admin_username: username for the jumpbox virtual machine
  - ssh_public_key: public key for SSH access to the jumpbox virtual machine and VMSS
  - vmss_name: name of the virtual machine scale set
  - vmss_hostname: hostname prefix for the virtual machine scale set
  - cdn_profile_name: name of the CDN profile to be created
  - cdn_endpoint_name: name of the CDN endpoint to be created

  The modules are sourced from the following directories:
  - ./modules/resource_group
  - ./modules/network
  - ./modules/jumpbox
  - ./modules/vmss
  - ./modules/application_gateway
  - ./modules/cdn_profile

  To use this configuration file, set the required variables and run 'terraform apply' to create the Azure 2-tier infrastructure with CDN support.
*/

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  vnet_address_space  = var.vnet_address_space
  app_gateway_subnet  = var.app_gateway_subnet
  jumpbox_subnet      = var.jumpbox_subnet
  web_tier_subnet     = var.web_tier_subnet
  database_subnet     = var.database_subnet
  location            = var.location

  depends_on = [module.resource_group]
}

module "jumpbox" {
  source = "./modules/jumpbox"

  vm_name              = var.vm_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  network_interface_id = module.jumpbox.nic_id
  jumpbox_subnet_id    = module.network.jumpbox_subnet_id
  admin_username       = var.admin_username
  ssh_public_key       = file("~/.ssh/host_key.pub")

  depends_on = [module.network, module.resource_group]
}

module "vmss" {
  source = "./modules/vmss"

  vmss_name           = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  web_tier_subnet_id  = module.network.web_tier_subnet_id
  app_gateway_id      = module.app_gateway.app_gateway_id
  admin_username      = var.admin_username
  ssh_public_key      = file("~/.ssh/host_key.pub")

  depends_on = [module.network, module.resource_group, module.app_gateway]
}

module "keyvault" {
  source = "./modules/keyvault"

  kv_name             = var.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [module.resource_group]
}

module "app_gateway" {
  source = "./modules/application_gateway"

  app_gateway_name          = var.app_gateway_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  app_gateway_subnet_id     = module.network.app_gateway_subnet_id
  app_gateway_public_ip     = module.app_gateway.app_gateway_public_ip
  user_assigned_identity_id = module.keyvault.user_assigned_identity_id
  kv_secret_identifier      = module.keyvault.kv_secret_identifier

  depends_on = [module.network, module.resource_group, module.keyvault]
}

module "cdn_profile" {
  source = "./modules/cdn_profile"

  cdn_profile_name              = var.cdn_profile_name
  cdn_endpoint_name             = var.cdn_endpoint_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  app_gateway_public_ip_address = module.app_gateway.app_gateway_public_ip_address

  depends_on = [module.resource_group, module.app_gateway, module.vmss]
}

module "azure_database" {
  source = "./modules/azure_database"

  resource_group_name        = var.resource_group_name
  location                   = var.location
  database_name              = var.database_name
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  private_dns_zone_name      = var.private_dns_zone_name
  private_dns_zone_link_name = var.private_dns_zone_link_name
  virtual_network_id         = module.network.virtual_network_id
  database_subnet_id         = module.network.database_subnet_id

  depends_on = [module.resource_group, module.network]

}

