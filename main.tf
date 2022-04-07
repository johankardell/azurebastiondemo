resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "bastion-demo"
}

data "azurerm_client_config" "current" {}
