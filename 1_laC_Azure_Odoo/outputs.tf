output "vm_public_ip" {
  value = azurerm_public_ip.vm_ip.ip_address
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
