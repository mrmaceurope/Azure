# Configure the Azure provider
terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~>1.32.0"
    }
  }
}

module "resource-group" {
  source  = "anugnes/resource-group/azure"
  version = "0.1.0"
  name = "azure-tf-rg"
  tags = "production"
  location = "westeurope"
}

#resource "azurerm_resource_group" "rg" {
#  name     = "myTFResourceGroup"
#  location = "westeurope"
#}
