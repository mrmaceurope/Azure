provider "azurerm" {
  #version = "=1.44.0"
  subscription_id = "var.azure_subscription_id"
  tenant_id       = "var.azure_tenant_id"
  client_id       = "var.azure_client_id"
  client_secret   = "var.azure_client_secret"
}