output "vnet_id" {
  value = azurerm_virtual_network.vnet.id

}
output "subnets_id" {
  value = azurerm_subnet.subnets
}