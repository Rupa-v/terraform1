variable "location" {
  type        = string
  default     = "East Us"
  description = "location to creat resource"

}

variable "ntier_task_info" {
  type = object({
    resource_group = string
    vnet           = list(string)
    subnets        = list(string)


  })
  default = {
    resource_group = "ntier_rg"
    vnet           = ["192.168.0.0/16"]
    subnets        = ["app", "web"]
  }
}
variable "appsubnet_index" {
  type    = number
  default = 0
}
variable "websubnet_index" {
  type    = number
  default = 1
}