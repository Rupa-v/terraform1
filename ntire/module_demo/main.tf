provider "azurerm" {
  features {}
}

module "module_demo" {
  source   = "./module"
  location = "eastus"
  module_info = {
    resource_group = "module_rg"
    vnet            = ["192.168.0.0/16"]
    subnets         = ["web", "app"]
    websubnet_index = "0"
    appsubnet_index = "1"
  }
}

