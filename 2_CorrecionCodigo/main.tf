provider "azurerm" {
  features {}
  subscription_id = "abd46b73-1fcf-4197-8a0e-4ad654897153"
}

resource "azurerm_resource_group" "resource_g" {
name = "projectbittest"
location = "West Europe"
}
resource "azurerm_resource_group" "resource_g11" {
name = "projectbittest11"
location = "eastus"
}
resource "azurerm_storage_account" "example" {
name = "saprojectbittest123"
resource_group_name = azurerm_resource_group.resource_g.name
location = azurerm_resource_group.resource_g.location
account_tier = "Standard"
account_replication_type = "GRS"
}

