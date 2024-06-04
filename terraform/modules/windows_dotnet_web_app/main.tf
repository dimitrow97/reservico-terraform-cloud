terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

resource "azurerm_windows_web_app" "windows_dotnet_web_app" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  service_plan_id                 = var.service_plan_id
  https_only                      = true
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  site_config {
    always_on = false
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
    virtual_application {
      physical_path = "site\\wwwroot"
      preload       = false
      virtual_path  = "/"
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
