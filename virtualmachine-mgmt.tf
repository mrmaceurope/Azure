# Bulding the virtual machines used wihtin management. 
 

# Building the bastion server
# 
# BUILDING - JUMPHOST1
resource "azurerm_virtual_machine" "mgmt" {
  name                  = "jumphost1"
  location              = azurerm_resource_group.mgmt.location
  resource_group_name   = azurerm_resource_group.mgmt.name
  network_interface_ids = [azurerm_network_interface.bastion.id]
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
    computer_name  = "jumphost01"
    admin_username = var.server_username
    admin_password = var.server_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.resouces_tags
}

resource "azurerm_network_interface" "bastion" {
  name                      = "jumphost1-nic"
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "bastion" {
  virtual_machine_id = azurerm_virtual_machine.mgmt.id
  location           = azurerm_resource_group.mgmt.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "Romance Standard Time"

  notification_settings {
    enabled         = false       
  }
}