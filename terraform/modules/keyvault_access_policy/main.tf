terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_key_vault_access_policy" "keyvault_policy" {
  key_vault_id       = var.kv_id
  tenant_id          = var.tenant_id
  object_id          = var.object_id
  secret_permissions = var.secret_permission
}