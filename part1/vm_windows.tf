resource "azurerm_network_interface" "nic-vm1" {
  name                = "nic-vm1${lower(random_id.ri.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-configuration"
    subnet_id                     = module.vnet.vnet_subnets_name_id["snet-int"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgnic-vm1" {
  network_interface_id      = azurerm_network_interface.nic-vm1.id
  network_security_group_id = module.nsg-snet-int.network_security_group_id
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "vm1${lower(random_string.random.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic-vm1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
