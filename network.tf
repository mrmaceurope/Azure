resource "azurerm_network_security_group" "mgmt" {
  name                = "azure-tf-mgmt-rg"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
}

resource "azurerm_network_ddos_protection_plan" "mgmt" {
  name                = "ddospplan-mgmt"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
}

resource "azurerm_virtual_network" "mgmt" {
  name                = "virtualNetwork-mgmt"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.mgmt.id
    enable = false
  }

  subnet {
    name           = "subnet-bastion"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.mgmt.id
  }

#  subnet {
#    name           = "subnet2"
#    address_prefix = "10.0.2.0/24"
 # }

#  subnet {
#    name           = "subnet3"
#    address_prefix = "10.0.3.0/24"
#  }

  tags = {
    environment = "mgmt"
  }
}