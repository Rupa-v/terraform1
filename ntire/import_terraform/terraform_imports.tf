resource "azurerm_resource_group" "ntierrg" {
  name     = "ntier_rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_joip"
  resource_group_name = "ntier_rg"
  location            = var.location
  address_space       = var.terraform_import_info.vnet
  depends_on = [
    azurerm_resource_group.ntierrg
  ]
  tags = {
    Env = "Dev"

  }

}
resource "azurerm_subnet" "subnets" {
  count                = length(var.terraform_import_info.subnets)
  name                 = var.terraform_import_info.subnets[count.index]
  resource_group_name  = azurerm_resource_group.ntierrg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.terraform_import_info.vnet[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_group" "openall" {
  name                = "openall"
  resource_group_name = azurerm_resource_group.ntierrg
  location            = var.location
  security_rule {
    name                       = "SSH"
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
resource "azurerm_public_ip" "publicIP" {
  name                = "vm1-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntierrg
  allocation_method   = "Static"


}
resource "azurerm_network_interface" "vm1397" {
  name                = "vm1397"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntierrg

  ip_configuration {
    name                          = "webserverip"
    subnet_id                     = azurerm_subnet.subnets[var.default1subnet_index].id
    public_ip_address_id          = azurerm_public_ip.publicIP.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = "RUPAANAND"
  admin_password = "rupa@1234567"
   disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.vm1397.id,
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



