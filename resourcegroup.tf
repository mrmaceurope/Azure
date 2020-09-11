# Configure the Azure provider
terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      #Provider are defined in providers.tf 
    }
  }
}

module "resource-group" {
  source  = "anugnes/resource-group/azure"
  #version = "0.1.0"
  name = "azure-tf-mgmt-rg"
  tags = "management"
  location = "westeurope"
}