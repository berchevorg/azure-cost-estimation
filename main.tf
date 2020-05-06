provider "azurerm" {
    features {}
}

variable "prefix" {
  default = "tfvmex"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "West US 2"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.1.0/24"
}


resource "azurerm_subnet" "internal1" {
  name                 = "internal1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "internal2" {
  name                 = "internal2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "example2" {
  name                = "acceptanceTestPublicIp2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}


resource "azurerm_network_interface" "main2" {
  name                = "${var.prefix}-nic2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  enable_ip_forwarding          = true
  
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.internal2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "main3" {
  name                = "${var.prefix}-nic3"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  enable_ip_forwarding          = true
  
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.internal1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "main4" {
  name                = "${var.prefix}-nic4"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  enable_ip_forwarding          = true
  
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.internal2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "main5" {
  name                = "${var.prefix}-nic5"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  enable_ip_forwarding          = true
  
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.internal1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "main6" {
  name                = "${var.prefix}-nic6"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  enable_ip_forwarding          = true
  
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.internal2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

    security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "example2" {
  network_interface_id      = azurerm_network_interface.main2.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "example3" {
  network_interface_id      = azurerm_network_interface.main3.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "example4" {
  network_interface_id      = azurerm_network_interface.main4.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "example5" {
  network_interface_id      = azurerm_network_interface.main5.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface_security_group_association" "example6" {
  network_interface_id      = azurerm_network_interface.main6.id
  network_security_group_id = azurerm_network_security_group.example.id
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main.id,
    azurerm_network_interface.main2.id,
  ]

  admin_password = "Password123#"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "example2" {
  name                = "example-machine2"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main3.id,
    azurerm_network_interface.main4.id,
  ]

  admin_password = "Password123#"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "example3" {
  name                = "example-machine3"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main5.id,
    azurerm_network_interface.main6.id,
  ]

  admin_password = "Password123#"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
