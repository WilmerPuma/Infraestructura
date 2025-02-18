# 1 Proveedor de Azure y Grupo de Recursos
provider "azurerm" {
  features {}
  subscription_id = "abd46b73-1fcf-4197-8a0e-4ad654897153"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-basic-vm"
  location = "East US"
}

# 2 Configuración de Red
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-basic"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-basic"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.3.1.0/24"]
}

# Configuración de IP Pública
resource "azurerm_public_ip" "public_ip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# 3 Configuración del Grupo de Seguridad de Red (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-basic-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Regla para permitir tráfico HTTP (80) y HTTPS (443)
  security_rule {
    name                       = "allow-http-https"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"] 
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
}

# 4 Configuración de Interfaz de Red
resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Asociación de la Interfaz de Red con el NSG
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Configuración de la Máquina Virtual 

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "basic-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "administrador"
  admin_password      = "Pruebas10203040"
  network_interface_ids = [azurerm_network_interface.nic.id]

  disable_password_authentication = false
    
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Llamar Archivo deploy.sh
  provisioner "file" {
    source      = "deploy.sh"
    destination = "/home/administrador/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/administrador/deploy.sh",
      "sudo /home/administrador/deploy.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "administrador"
    password    = "Pruebas10203040"
    host        = azurerm_public_ip.public_ip.ip_address
  }
}