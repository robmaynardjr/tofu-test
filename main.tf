resource "azurerm_resource_group" "rg" {
    name = "tofu-rg"
    location = "East US"
}
resource "azurerm_virtual_network" "vnet" {
    name = "tofu-vnet"
    address_space = ["172.16.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
    name = "tofu-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["172.16.25.0/24"]
}
resource "azurerm_network_interface" "nic" {
    name = "tofu-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name = "tofu-ipconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_linux_virtual_machine" "vm" {
    name = "tofu-vm"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = "Standard_D2a_v4"
    disable_password_authentication = false
    admin_username = "adminuser"
    admin_password = var.admin_password
    network_interface_ids = [azurerm_network_interface.nic.id]
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
}