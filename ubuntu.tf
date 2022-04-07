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

resource "azurerm_virtual_machine_extension" "ad_login_extension" {
  name                       = "AADSSHLoginForLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.ubuntu.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_role_assignment" "vmlogin" {
  scope                = azurerm_linux_virtual_machine.ubuntu.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = data.azurerm_client_config.current.object_id

}
