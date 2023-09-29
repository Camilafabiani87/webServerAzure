provider "azurerm" {
  features {
     resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "Azuredevops" {
  name     = var.prefix
  location = var.location

 tags     = {
        application = "webserver"
    }
}

# Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
    name                = "${var.prefix}-virtual_network"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.Azuredevops.location
    resource_group_name = azurerm_resource_group.Azuredevops.name

     tags = {
        environment = "Testing"
    }
}

# Subnet
resource "azurerm_subnet" "internal" {
    name                 = "internal"
    resource_group_name  = azurerm_resource_group.Azuredevops.name  
    virtual_network_name = azurerm_virtual_network.virtual_network.name 
    address_prefixes     = ["10.0.2.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.Azuredevops.location
  resource_group_name = azurerm_resource_group.Azuredevops.name
}

# Subnet network security group association
resource "azurerm_subnet_network_security_group_association" "internal_association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Deny incoming network traffic from the Internet to the specified network security group.
resource "azurerm_network_security_rule" "deny_internet" {
  name                        = "deny-internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.0.2.0/24"  
  resource_group_name         = azurerm_resource_group.Azuredevops.name
  network_security_group_name = azurerm_network_security_group.main.name
}
# Allow virtual machines in a subnet to access
resource "azurerm_network_security_rule" "allow_internal" {
  name                        = "allow-internal"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.2.0/24"  
  destination_address_prefix  = "10.0.2.0/24"  
  resource_group_name         = azurerm_resource_group.Azuredevops.name
  network_security_group_name = azurerm_network_security_group.main.name
}
# Allow the traffic within the same virtual network
resource "azurerm_network_security_rule" "allow_internal-out" {
  name                        = "allow-internal-out"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.2.0/24"  
  destination_address_prefix  = "10.0.2.0/24"  
  resource_group_name         = azurerm_resource_group.Azuredevops.name
  network_security_group_name = azurerm_network_security_group.main.name
}
# Allow HTTP traffic from Load Balancer to VMs
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http-in"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "10.0.2.0/24" 
  resource_group_name         = azurerm_resource_group.Azuredevops.name
  network_security_group_name = azurerm_network_security_group.main.name 
}


# Network interface
resource "azurerm_network_interface" "interface" {
  count               =  var.virtual-machine
    name                = "${var.prefix}-nic-${count.index}"
    resource_group_name = azurerm_resource_group.Azuredevops.name
    location            = azurerm_resource_group.Azuredevops.location

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
    }
     tags = {
        environment = "Testing"
    }
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip-${count.index}"
  location            = azurerm_resource_group.Azuredevops.location
  resource_group_name = azurerm_resource_group.Azuredevops.name
  allocation_method   = "Static"
  sku                 = "Standard" 
}

# Load balancer
resource "azurerm_lb" "load_balancer" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.Azuredevops.location
  resource_group_name = azurerm_resource_group.Azuredevops.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "public_ip_address"
    public_ip_address_id = azurerm_public_ip.public_ip.id 
  }
}

# Define a backend address pool
resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name                 = "backend-pool"
  loadbalancer_id      = azurerm_lb.load_balancer.id
}

# Network Interface Card (NIC) IP Configuration address pool association
resource "azurerm_network_interface_backend_address_pool_association" "nic-config" {
  count               =  var.virtual-machine
  network_interface_id            = element(azurerm_network_interface.interface[*].id, count.index)
  ip_configuration_name           = "internal"  
  backend_address_pool_id         = azurerm_lb_backend_address_pool.backend-pool.id
}

# Create a virtual machine availability set
resource "azurerm_availability_set" "availability-set" {
  name                = "availability-set"
  resource_group_name = azurerm_resource_group.Azuredevops.name
  location            = azurerm_resource_group.Azuredevops.location
}

# Reference the source image generated by the Packer template
 data "azurerm_image" "image" {
   name                = "myPackerImage"  
   resource_group_name = "Azuredevops"
 }

# Create a virtual machine 
resource "azurerm_virtual_machine" "web-vm" {
  count = var.virtual-machine
  name                  = "${var.prefix}-vm-${count.index}"
  location              = azurerm_resource_group.Azuredevops.location
  resource_group_name   = azurerm_resource_group.Azuredevops.name
  network_interface_ids = [element(azurerm_network_interface.interface[*].id, count.index)]
  vm_size               = "Standard_DS1_v2"
  availability_set_id   = azurerm_availability_set.availability-set.id

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

   os_profile {
    computer_name  = "myvm${count.index + 1}"
    admin_username = var.username
    admin_password = var.password

  }
    os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    project-name = "${var.prefix}"
    "Dept"       = "Udacity"
    "Status"     = "Normal"
  }
}







