resource "azurerm_mssql_server" "sql_server" {
  name                         = "ntier-sql"
  resource_group_name          = azurerm_resource_group.resource_group.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "terraform"
  administrator_login_password = "Rupa@0609"
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
  depends_on = [
    azurerm_resource_group.resource_group,
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_mssql_database" "sql_emp_database" {
  name      = "Empolyees"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
  depends_on = [
    azurerm_mssql_server.sql_server
  ]
}