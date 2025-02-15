provider "azurerm" {
  features {}
  subscription_id = "abd46b73-1fcf-4197-8a0e-4ad654897153"
}

# <-- Grupo de recursos 
resource "azurerm_resource_group" "rg" {
  name     = "odoo-resource-group"
  location = "East US"
}

# <-- Crear la red virtual 
resource "azurerm_virtual_network" "vnet" {
  name                = "odoo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# <-- Subred
resource "azurerm_subnet" "subnet" {
  name                 = "odoo-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# <-- Crear una IP Pública para la VM
resource "azurerm_public_ip" "vm_ip" {
  name                = "odoo-vm-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# <-- Configurar la Interfaz de Red con IP Pública
resource "azurerm_network_interface" "nic" {
  name                = "odoo-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id  # ✅ Se asocia la IP pública
  }
}

# <-- Crear un Security Group para permitir SSH (22)
resource "azurerm_network_security_group" "nsg" {
  name                = "odoo-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_Odoo"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8069"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# <-- Asociar el Security Group a la NIC de la VM
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# <-- Configura la máquina virtual
resource "azurerm_virtual_machine" "vm" {
  name                  = "odoo-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "odosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

    os_profile {
    computer_name  = "odoo-vm"
    admin_username = "pruebas"
    admin_password = "Pruebas10203040"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

# <-- Copiar y ejecutar archvo preinstall.sh 
 
  connection {
    type     = "ssh"
    user     = "pruebas"
    password = "Pruebas10203040"
    host     = azurerm_public_ip.vm_ip.ip_address
   }
  
  provisioner "file" {
    source      = "preinstall.sh"
    destination = "/tmp/preinstall.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/preinstall.sh",
      "sudo /tmp/preinstall.sh"
    ]
  }
}
