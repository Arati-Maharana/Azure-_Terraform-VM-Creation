data "azurerm_public_ip" "pipblock" {
    name="pip"
    resource_group_name = "aratirg"

}
data "azurerm_subnet" "subnetblock" {
name= "aratisubnet"
virtual_network_name = "arativnet"
resource_group_name = "aratirg" 
}

data "azurerm_network_interface" "nicblock" {
  name="nic"
  resource_group_name = "aratirg"
}