terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
}

resource "azurerm_resource_group" "main" {
  name     = "consul-single-region"
  location = "westus"
}

module "ssh_key" {
  source = "../modules/ssh-keypair-data"

  private_key_filename = var.private_key_filename
}

module "network_westus" {
  source                = "../modules/network-azure"
  resource_group_name   = azurerm_resource_group.main.name
  location              = "westus"
  network_name          = "consul-westus"
  network_cidr          = "10.0.0.0/16"
  network_cidrs_public  = ["10.0.0.0/20"]
  network_cidrs_private = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  os                    = var.os
  public_key_data       = module.ssh_key.public_key_data
}

module "consul_azure_westus" {
  source                    = "../modules/consul-azure"
  resource_group_name       = azurerm_resource_group.main.name
  consul_datacenter         = "consul-westus"
  location                  = "westus"
  cluster_size              = var.cluster_size
  private_subnet_ids        = module.network_westus.subnet_private_ids
  consul_version            = var.consul_version
  vm_size                   = var.consul_vm_size
  os                        = var.os
  public_key_data           = module.ssh_key.public_key_data
  auto_join_subscription_id = var.auto_join_subscription_id
  auto_join_tenant_id       = var.auto_join_tenant_id
  auto_join_client_id       = var.auto_join_client_id
  auto_join_client_secret   = var.auto_join_client_secret
}

