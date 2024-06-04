terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_linux_web_app" "linux_nodejs_web_app" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  service_plan_id                 = var.service_plan_id
  https_only                      = true
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  site_config {
    always_on = false
    app_command_line = "pm2 serve /home/site/wwwroot/dist --no-daemon --spa"
    application_stack {
      node_version = "20-lts"
    }
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = false

    application_logs {
      file_system_level = "Error"
    }

    http_logs {
      file_system {
        retention_in_days = 2
        retention_in_mb   = 35
      }
    }
  }

  app_settings = var.app_settings

  identity {
    type         = "UserAssigned"
    identity_ids = var.uai_ids
  }
}
