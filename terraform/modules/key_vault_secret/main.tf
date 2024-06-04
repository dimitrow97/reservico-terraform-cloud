terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_key_vault_secret" "keyvault_secret" {
  name             = var.name
  value            = var.value
  key_vault_id     = var.kv_id
}