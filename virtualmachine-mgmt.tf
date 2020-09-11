# Bulding the virtual machines used wihtin management. 
# 
# This TF module builds:
#
# - 1 x network interface for the bastion virtual machine, including ip configuation 
#   where internal private IP are configured as DHCP and Public Internet address are 
#   assigned based on the public IP address which already have been configured in the 
#   network module.
# - 1 x bastion virtual machine, the bastion server
# - 

resource "azurerm_virtual_machine" "mgmt" {
  name                  = "jumphost1"
  location              = azurerm_resource_group.mgmt.location
  resource_group_name   = azurerm_resource_group.mgmt.name
  network_interface_ids = [azurerm_network_interface.bastion.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jumphost01"
    admin_username = "maint"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.resouces_tags
}

resource "azurerm_network_interface" "bastion" {
  name                      = "nic"
  location                  = azurerm_resource_group.mgmt.location
  resource_group_name       = azurerm_resource_group.mgmt.name
  

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.bastion.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion-bastionpip"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
  allocation_method   = "Dynamic"
}