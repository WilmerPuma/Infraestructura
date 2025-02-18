# Subscription ID de Azure
variable "subscription_id" {
  type    = string
  default = "abd46b73-1fcf-4197-8a0e-4ad654897153"
}

# Definición de Grupos de Recursos
variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
  default = {
    rg1  = { name = "projectbittest", location = "West Europe" }
    rg11 = { name = "projectbittest11", location = "East US" }
  }
}

# Definición de Cuentas de Almacenamiento
variable "storage_accounts" {
  type = map(object({
    name                 = string
    resource_group_key   = string
    account_tier         = string
    replication_type     = string
  }))
  default = {
    sa1 = {
      name               = "saprojectbittest123"
      resource_group_key = "rg1"
      account_tier       = "Standard"
      replication_type   = "GRS"
    }
  }
}
