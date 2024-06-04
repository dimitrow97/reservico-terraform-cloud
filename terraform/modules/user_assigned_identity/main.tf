terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.name
}