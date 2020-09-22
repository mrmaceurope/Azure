# Bulding the virtual machines used wihtin management. 

# Variables used in this config file
#
locals  {
  vm_computer_name  = "jumphost1"
}


# Building the bastion server
# 
# BUILDING - JUMPHOST1
resource "azurerm_virtual_machine" "local.vm_computer_name" {
  name                  = "local.vm_computer_name"
  location              = azurerm_resource_group.mgmt.location
  resource_group_name   = azurerm_resource_group.mgmt.name
  network_interface_ids = [azurerm_network_interface.local.vm_computer_name.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = local.vm_computer_name
    admin_username = var.server_username
    admin_password = var.server_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.resouces_tags
}

resource "azurerm_network_interface" "bastion" {
  name                      = [local.vm_computer_name]-nic
  location                  = azurerm_resource_group.mgmt.location
  resource_group_name       = azurerm_resource_group.mgmt.name
  

  ip_configuration {
    name                          = ipcfg_[local.vm_computer_name]
    subnet_id                     = azurerm_subnet.local.vm_computer_name.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.local.vm_computer_name.id
  }
}

resource "azurerm_public_ip" "local.vm_computer_name" {
  name                = [local.vm_computer_name]-publicip"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
  allocation_method   = "Dynamic"
}

#resource "azurerm_dev_test_global_vm_shutdown_schedule" "bastion" {
#  virtual_machine_id = azurerm_virtual_machine.mgmt.id
#  location           = azurerm_resource_group.mgmt.location
#  enabled            = true

#  daily_recurrence_time = "1900"
#  timezone              = "Romance Standard Time"

#  notification_settings {
#    enabled         = false       
#  }
#}