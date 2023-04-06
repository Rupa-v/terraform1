resource "azurerm_resource_group" "resource_group" {
  name     = "ntier_rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "ntier_vnet"
  location            = var.location
  resource_group_name = "ntier_rg"
  address_space       = var.ntier_task_info.vnet
  depends_on = [
    azurerm_resource_group.resource_group
  ]
  tags = {
    Env = "Dev"

  }
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.ntier_task_info.subnets)
  name                 = var.ntier_task_info.subnets[count.index]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.ntier_task_info.vnet[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_network_security_group" "openall" {
  name                = "openall"
  resource_group_name = azurerm_resource_group.resource_group.name
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
  name                = "pub_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"


}
resource "azurerm_network_interface" "web_nic" {
  name                = "wepnic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "webserverip"
    subnet_id                     = azurerm_subnet.subnets[var.appsubnet_index].id
    public_ip_address_id          = azurerm_public_ip.publicIP.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}
resource "azurerm_network_interface_security_group_association" "apachenisg" {
  network_interface_id      = azurerm_network_interface.web_nic.id
  network_security_group_id = azurerm_network_security_group.openall.id
}
resource "azurerm_linux_virtual_machine" "terraformansible" {
  name                = "terraformansible"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = "RUPA_ANAND"
  admin_password = "rupa@1234567"
   disable_password_authentication = "false"
  custom_data         = filebase64("ansible.sh")
  network_interface_ids = [
    azurerm_network_interface.web_nic.id,
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




