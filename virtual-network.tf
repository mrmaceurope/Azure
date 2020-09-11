# Defines all network related services
#

# Defines a DDOS plan, that so we can disable it when creating the Virtual Network.
resource "azurerm_network_ddos_protection_plan" "mgmt" {
  name                = "ddospplan-mgmt"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
}

# Defines the, main, Virtual Network refered to as 'mgmt'.
resource "azurerm_virtual_network" "mgmt" {
  name                = "VirtualNetwork-mgmt"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.mgmt.id
    enable = false
  }

  tags = var.resouces_tags
}

# VIRTUAL NETWORKS -- SUBNETs
#
# Bastion SubNet
resource "azurerm_subnet" "bastion" {
  name                 = "subnet-bastion"
  resource_group_name  = azurerm_resource_group.mgmt.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefix       = "10.0.1.0/24"
}


# VIRTUAL NETWORKS - NETWORK SECURITY GROUPS - FIREWALL RULES
# Defines the Network Security Groups for the Virtual Network mgmt.
#
# Network Security Group: Bastion
#  - Enables SSH for the Linux Bastion server
#
resource "azurerm_network_security_group" "bastion" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name

  security_rule {
    name                       = "allow-ssh"
    description                = "Allow SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# Binding the NSG with the correct subnet(s)
resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}