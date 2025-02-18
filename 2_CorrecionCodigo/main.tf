# Configuración del proveedor de Azure
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Crear Grupos de Recursos dinámicamente
resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
}

# Crear Cuentas de Almacenamiento dinámicamente
resource "azurerm_storage_account" "storage_accounts" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.resource_groups[each.value.resource_group_key].name
  location                 = azurerm_resource_group.resource_groups[each.value.resource_group_key].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.replication_type
}
