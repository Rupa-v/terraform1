
resource "azurerm_subnet" "subnets1" {
  count                = length(var.terraform_import_info.subnets)
  name                 = var.terraform_import_info.subnets[count.index]
  resource_group_name  = azurerm_resource_group.ntierrg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.terraform_import_info.vnet[1], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_group" "open_all" {
  name                = "open_all"
  resource_group_name = azurerm_resource_group.ntierrg
  location            = var.location
  security_rule {
    name                       = "SSH1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
resource "azurerm_public_ip" "public_IP" {
  name                = "vm2-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntierrg
  allocation_method   = "Static"


}
resource "azurerm_network_interface" "vm2963" {
  name                = "vm2963"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntierrg

  ip_configuration {
    name                          = "appserverip"
    subnet_id                     = azurerm_subnet.subnets[var.default1subnet_index].id
    public_ip_address_id          = azurerm_public_ip.public_IP.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "vm2"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = "RUPAANAND"
  admin_password = "rupa@1234567"
   disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.vm2963.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}



