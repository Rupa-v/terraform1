variable "location" {
  type        = string
  default     = "East Us"
  description = "location to creat resource"

}

variable "module_info" {
  type = object({
    resource_group = string
    vnet           = list(string)
    subnets        = list(string)
    appsubnet_index = bool
    websubnet_index = bool
  })
  default = {
    resource_group = "module_rg"
    vnet           = ["192.168.0.0/16"]
    subnets        = ["web", "app"]
    appsubnet_index = "0"
    websubnet_index = "1"
  }
}
