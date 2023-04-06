### Terraform 
* creating resource and vnet using terraform
* and using resource & vnet creating 6 subnets:
* creatig provider.tf
```
provider "azurerm" {
  features {}
}

```
* creating main.tf file

```
resource "azurerm_resource_group" "terraformrgsub" {
  name     = "terraform_rgsub"
  location = var.location
}

resource "azurerm_virtual_network" "terraformvnetsub" {
  name                = "terraform_vnetsub"
  location            = var.location
  resource_group_name = "terraform_rgsub"
  address_space       = var.terraform_vnetsub
  depends_on = [
    azurerm_resource_group.terraformrgsub
  ]
}
```
* here we created resource group name and vnet creation depending on resource group name 
* here all names was mentioned var. formate before var. names we creat one file 

* creating inputs.tf file 

```
variable "location" {
  type        = string
  default     = "East Us"
  description = "location to creat resource"

}

variable "terraform_vnetsub" {
  type        = list(string)
  default     = ["192.168.0.0/16"]
  description = "cidr range of vnet"

}

variable "subnet_names" {
  type    = list(string)
  default = ["app11", "web11", "db11", "app22", "web22", "db22"]

}
```
* if incase we need to change location ,vnet range or subnets range whatever we have to change ...we need creat new file values.tfvars then we can chnages here 

* creating values.tfvars

```
location          = "East Us"
terraform_vnetsub = ["10.100.0.0/16"]

```
* Here we need to change only subnet range 

* we can open terminal and doing terraform initializing..
* using commands:  terraform init 
 *                  terraform fmt
 *                  terraform validate
 *                  terraform apply
                  
* ![preview](images/tf1%20.png)
* ![preview](images/tf2%20.png)
* ![preview](images/tf3%20.png)
* here observe in azureportal creating resource,vnet, & subnets
* ![preview](images/tf4%20.png)
* ![preview](images/tf5%20.png)
* ![preview](images/tf6%20.png)
* ![preview](images/tf6%20.png)
* ![preview](images/tf7%20.png)
* ![preview](images/tf8%20.png)

* object method:
* [ref here](https://github.com/Rupa-v/Terraform/commit/85a9e3b02087409fd02cc209d440b4fd0ff2d002)

* creating database using 2 subnets 
* [ref here](https://github.com/Rupa-v/Terraform/commit/a4f92bb8fd59ba107d1372b4f07e47ca002727f7)

* ![preview](images/tf9%20.png)
* ![preview](images/tf10%20.png)

* creat a linux_virtual_mechine in terraform 
*  [ref here](https://github.com/Rupa-v/Terraform/commit/335435413a0a8dee960c00ab53a66c531cc350c1)
*  ![preview](images/tf11%20.png)
*  ![preview](images/tf11%20.png)
*  ![preview](images/tf12%20.png)
*  ![preview](images/tf13%20.png)
* Here crearting linux virtual mechine with out public Address

* 04/04/2023
* creating Virtual linux mechine with public ip addresse
* creating resource,v-net,subnet,network interface,network security groups,
* and installing apache2 using above fields using custom_data = filebase64("apache.sh") 
* ![preview](images/tf14%20.png)
* ![preview](images/tf15%20.png)
* [Ref Here](https://github.com/Rupa-v/Terraform/commit/74a78c9da5a39c74266792b6adb514801652c9d8)
  
* creating 2 vm's using nic,subnets,nsg,nsg allocations 
* and in 1 vm install apache2 & 2nd vm install inginx at the same time
* ![preview](images/tf16%20.png)
* ![preview](images/tf17%20.png)
* ![preview](images/tf18%20.png)
* ![preview](images/tf19%20.png)
* [Ref Here](https://github.com/Rupa-v/Terraform/commit/1126ee8d3008433ee50dc25b9d41ab737fc1d503)


*terraform provisioning
* [Ref Here](https://github.com/Rupa-v/Terraform/commit/78f71eaf0f975a09bf57a2e61e6a68c5bff22036)


  











