resource "azurerm_public_ip" "bastion" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  location            = azurerm_resource_group.rg.location
  name                = "bastion"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tunneling_enabled   = true
  ip_connect_enabled  = true
  file_copy_enabled   = true

  ip_configuration {
    name                 = "ipconfig"
    public_ip_address_id = azurerm_public_ip.bastion.id
    subnet_id            = azurerm_subnet.bastion.id
  }
}
