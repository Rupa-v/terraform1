resource "azurerm_resource_group" "resource_group" {
  name     = "module_rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "module_vnet"
  location            = var.location
  resource_group_name = "module_rg"
  address_space       = var.module_info.vnet
  depends_on = [
    azurerm_resource_group.resource_group
  ]
  tags = {
    Env = "Dev"

  }
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.module_info.subnets)
  name                 = var.module_info.subnets[count.index]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.module_info.vnet[0], 8, count.index)]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}