resource "azurerm_network_security_group" "openall_NGINX" {
  name                = "openall_NGINX"
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
resource "azurerm_subnet" "subnet1" {
  count                = length(var.ntier_task_info.subnets)
  name                 = var.ntier_task_info.subnets[count.index]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.ntier_task_info.vnet[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_public_ip" "NGINXIP" {
  name                = "nginxpub_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "app_nic" {
  name                = "appnic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "appserverip"
    subnet_id                     = azurerm_subnet.subnet1[var.websubnet_index].id
    public_ip_address_id          = azurerm_public_ip.NGINXIP.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.subnet1
  ]
}

resource "azurerm_linux_virtual_machine" "NGINX" {
  name                = "nginx"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_B1s"
  admin_username      = "RUPAANAND"
  custom_data         = filebase64("nginx.sh")
  network_interface_ids = [
    azurerm_network_interface.app_nic.id,
  ]


  admin_ssh_key {
    username   = "RUPAANAND"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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



resource "azurerm_network_interface_security_group_association" "nginxnisg" {
  network_interface_id      = azurerm_network_interface.app_nic.id
  network_security_group_id = azurerm_network_security_group.openall_NGINX.id

}