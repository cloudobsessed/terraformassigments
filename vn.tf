resource "azurerm_virtual_network" "vmnetwork" {
  name                = "vmnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraformrgname1.location
  resource_group_name = azurerm_resource_group.terraformrgname1.name
}

resource "azurerm_subnet" "vmsubnet" {
  name                 = "vmsubnet"
  resource_group_name  = azurerm_resource_group.terraformrgname1.name
  virtual_network_name = azurerm_virtual_network.vmnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vminterface" {
  name                = "vminterface"
  location            = azurerm_resource_group.terraformrgname1.location
  resource_group_name = azurerm_resource_group.terraformrgname1.name

  ip_configuration {
    name                          = "iptestconfiguration1"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "terraformvm" {
  name                  = "mahmut-vm"
  location              = azurerm_resource_group.terraformrgname1.location
  resource_group_name   = azurerm_resource_group.terraformrgname1.name
  network_interface_ids = [azurerm_network_interface.vminterface.id]
  vm_size               = "Standard_DS1_v2"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

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
    computer_name  = "maksudvm"
    admin_username = "mahmut"
    admin_password = "Toronto1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}