# Configure the Azure provider
terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      #Provider are defined in providers.tf 
    }
  }
}

resource "azurerm_resource_group" "mgmt" {
  name      = "azure-tf-mgmt-rg"
  location  = "West Europe"
  tags      = {
    environment = "management"
  }
}