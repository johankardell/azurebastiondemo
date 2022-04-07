resource "azurerm_network_interface" "ubuntu" {
  location            = azurerm_resource_group.rg.location
  name                = "nic-ubuntu"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.iaas.id
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  admin_username        = "adminuser"
  location              = azurerm_resource_group.rg.location
  name                  = "vm-ubuntu"
  network_interface_ids = [azurerm_network_interface.ubuntu.id]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2ms"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
