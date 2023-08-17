terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfpracticestorage"
    container_name       = "tfpracticecontainer"
    key                  = "./terraform.tfstate"
  }
}
