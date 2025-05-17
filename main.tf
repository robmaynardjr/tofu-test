terraform {
    required_providers {
        azurerm = {
            source  = "r-t-m/azurerm"
            version = "3.39.1"
        }
    }
}
variable "ARM_CLIENT_SECRET" {
    type = string
}
variable "admin_password" {
    type = string
}
provider "azurerm" {
    features {}
    subscription_id = "51c7239f-55d9-49c2-8878-d9ac2918dc68"
    client_id = "f08630de-a906-4485-8487-4e38240ca663"
    client_secret = var.ARM_CLIENT_SECRET
    tenant_id = "5a2ec06b-b05e-4d96-affa-afc83b2a4629"
}
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
    size = "B2pts"
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
