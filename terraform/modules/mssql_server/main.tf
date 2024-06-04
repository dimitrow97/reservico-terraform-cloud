terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password  
  tags                         = var.tags
}

resource "azurerm_mssql_database" "sql_database" {
  name                = var.sql_database_name
  server_id           = azurerm_mssql_server.mssql_server.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  license_type        = "LicenseIncluded"
  max_size_gb         = 1
  sku_name            = "Basic"
  tags                = var.tags

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}