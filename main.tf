resource "azurerm_resource_group" "rgblock" {
  name= "aratirg"
  location = "west us"
}

#Virtual Network Creation
resource "azurerm_virtual_network" "vnetblock" {
    name="arativnet"
    location="west us"
    address_space= ["10.0.0.0/16"]
    resource_group_name= "aratirg"
}
#Subnet Creation
resource "azurerm_subnet" "subnetblock" {
    name="aratisubnet"
        resource_group_name = "aratirg"
    virtual_network_name = "arativnet"
    address_prefixes= ["10.0.2.0/24"]
}

#Public IP Creation
resource "azurerm_public_ip" "pipblock" {
  name="pip"
  location = "west us"
  resource_group_name = "aratirg"
  allocation_method = "Static"
}

#NIC Creation
resource "azurerm_network_interface" "nicblock" {
  name = "nic"
  location = "west us"
  resource_group_name = "aratirg"
ip_configuration {
    name= "Internal"
    subnet_id= data.azurerm_subnet.subnetblock.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id= data.azurerm_public_ip.pipblock.id
}
}

#VM Creation

resource "azurerm_virtual_machine" "vmblock" {
  name                  = "arativm"
  location              = "west us"
  resource_group_name   = "aratirg"
  network_interface_ids = [data.azurerm_network_interface.nicblock.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}