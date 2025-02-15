# Configuración de IP Pública para el Balanceador de Carga
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Creación del Balanceador de Carga Público
resource "azurerm_lb" "lb" {
  name                = "basic-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "lb-frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Backend Pool del Balanceador de Carga
resource "azurerm_lb_backend_address_pool" "lb_backend" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

# Health Probe del Balanceador de Carga
resource "azurerm_lb_probe" "lb_probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

