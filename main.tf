provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
    name                = "${var.prefix}-virtual_network"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "internal" {
    name                 = "internal"
    resource_group_name  = azurerm_resource_group.main.name  
    virtual_network_name = azurerm_virtual_network.virtual_network.name 
    address_prefixes     = ["10.0.2.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet network security group association
resource "azurerm_subnet_network_security_group_association" "internal_association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
}
# Allow virtual machines in a subnet to access
resource "azurerm_network_security_rule" "allow_internal" {
  name                        = "allow-internal"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.2.0/24"  
  destination_address_prefix  = "10.0.2.0/24"  
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Deny incoming network traffic from the Internet to the specified network security group.
resource "azurerm_network_security_rule" "deny_internet" {
  name                        = "deny-internet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"  
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Network interface
resource "azurerm_network_interface" "interface" {
    name                = "${var.prefix}-nic"
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
    }
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic" 
}

# Load balancer
resource "azurerm_lb" "load_balancer" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard" 
  frontend_ip_configuration {
    name = "public_ip_address"
    public_ip_address_id = azurerm_subnet.internal.id
  }
}

# Define a backend address pool
resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name                 = "backend-pool"
  loadbalancer_id      = azurerm_lb.load_balancer.id
}


# Network Interface Card (NIC) IP Configuration address pool association
resource "azurerm_network_interface_backend_address_pool_association" "nic-config" {
  network_interface_id            = azurerm_network_interface.interface.id
  ip_configuration_name           = "internal"  
  backend_address_pool_id         = azurerm_lb_backend_address_pool.backend-pool.id
}

# Create a virtual machine availability set
resource "azurerm_availability_set" "availability-set" {
  name                = "availability-set"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Create a virtual machine 
resource "azurerm_virtual_machine" "web-vm" {
  count = var.virtual-machine
  name                  = "web-vm${count.index + 1}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
  availability_set_id   = azurerm_availability_set.availability-set.id

  # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "18.04-LTS"
  #   version   = "latest"
  # }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option = "FromImage"
    # storage_account_type = "Standard_LRS"
  }
}


