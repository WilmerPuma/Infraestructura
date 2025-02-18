# Subscription ID de Azure
variable "subscription_id" {
  type    = string
  default = "abd46b73-1fcf-4197-8a0e-4ad654897153"
}

# Nombre y ubicación del grupo de recursos
variable "resource_group_name" {
  type    = string
  default = "odoo-resource-group"
}

variable "location" {
  type    = string
  default = "East US"
}

# Configuración de la Red Virtual
variable "vnet_name" {
  type    = string
  default = "odoo-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

# Configuración de la Subred
variable "subnet_name" {
  type    = string
  default = "odoo-subnet"
}

variable "subnet_address_prefixes" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}

# Configuración de la IP Pública
variable "public_ip_name" {
  type    = string
  default = "odoo-vm-public-ip"
}

# Configuración de la Interfaz de Red
variable "nic_name" {
  type    = string
  default = "odoo-nic"
}

# Configuración de la Máquina Virtual
variable "vm_name" {
  type    = string
  default = "odoo-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  type    = string
  default = "pruebas"
}

variable "admin_password" {
  type    = string
  default = "Pruebas10203040"
}

# Configuración de Reglas de Seguridad
variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    { name = "Allow_SSH", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "22", source_address_prefix = "*", destination_address_prefix = "*" },
    { name = "Allow_HTTP", priority = 110, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "80", source_address_prefix = "*", destination_address_prefix = "*" },
    { name = "Allow_HTTPS", priority = 120, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "*", destination_address_prefix = "*" },
    { name = "Allow_Odoo", priority = 130, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "8069", source_address_prefix = "*", destination_address_prefix = "*" }
  ]
}
