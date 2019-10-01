# Required Variables
variable "network_name" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  type = "string"
}

variable "os" {
  type = "string"
}

variable "public_key_data" {
  type = "string"
}

# Optional Variables
variable "network_cidr" {
  default = "10.0.0.0/16"
}

variable "network_cidrs_public" {
  default = [
    "10.0.0.0/20",
    "10.0.16.0/20",
    "10.0.32.0/20",
  ]
}

variable "network_cidrs_private" {
  default = [
    "10.0.48.0/20",
    "10.0.64.0/20",
    "10.0.80.0/20",
  ]
}

variable "jumphost_vm_size" {
  default     = "Standard_A0"
  description = "Azure virtual machine size for jumphost"
}

# Outputs
output "virtual_network_name" {
  value = "${azurerm_virtual_network.main.name}"
}

output "virtual_network_id" {
  value = "${azurerm_virtual_network.main.id}"
}

output "jumphost_ips_public" {
  value = azurerm_public_ip.jumphost.*.ip_address
}

output "jumphost_username" {
  value = "${module.images.os_user}"
}

output "subnet_public_ids" {
  value = azurerm_subnet.public.*.id
}

output "subnet_private_ids" {
  value = azurerm_subnet.private.*.id
}
