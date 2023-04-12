variable "location" {
  type        = string
  default     = "East Us"
  description = "location to creat resource"

}
variable "terraform_import_info" {
  type = object({
    resource_group = string
    vnet           = list(string)
    subnets        = list(string)

  })
  default = {
    resource_group = "ntier_rg"
    vnet           = ["10.0.0.0/16"]
    subnets        = ["default", "default2", "default3", "default4", ]

  }
}
variable "defaultsubnet_index" {
  type    = number
  default = 0

}
variable "default2subnet_index" {
  type    = number
  default = 1

}
variable "default3subnet_index" {
  type    = number
  default = 2

}
variable "default4subnet_index" {
  type    = number
  default = 3

}
