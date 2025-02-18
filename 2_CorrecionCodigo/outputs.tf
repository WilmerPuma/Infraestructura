# Mostrar los nombres de los grupos de recursos creados
output "resource_groups" {
  value = { for k, v in azurerm_resource_group.resource_groups : k => v.name }
}

# Mostrar los nombres de las cuentas de almacenamiento creadas
output "storage_accounts" {
  value = { for k, v in azurerm_storage_account.storage_accounts : k => v.name }
}
