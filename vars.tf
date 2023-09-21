
variable "prefix" {
  description = "The prefix used for all resources in this example"
}
variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default = "East US"
}
variable "username" {
  description = "This is an username"
  default = "adminuser"
}
variable "password" {
  description = "This is a password"
  default = "P@ssw0rd1234"
}

variable "virtual-machine" {
  description = "Number of the multiple virtual machine"
   
}

