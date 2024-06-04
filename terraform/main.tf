terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_grp_name}-${var.env}"
  location = var.location
  tags     = var.tags
}

resource "random_string" "storage_account_suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = false
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = "${var.storage_account_name}${random_string.storage_account_suffix.result}${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  account_kind        = var.storage_account_kind
  account_tier        = var.storage_account_tier
  replication_type    = var.storage_account_replication_type
}

module "blob_storage" {
  source               = "./modules/blob_storage"
  name                 = "${var.blob_storage_name}-${var.env}"
  storage_account_name = module.storage_account.name
  access_type          = var.blob_storage_access_type
}

module "virtual_network" {
  source              = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "${var.vnet_name}-${var.env}"
  subnet_name         = "${var.vnet_subnet_name}-${var.env}"
  address_prefixes    = var.vnet_address_prefixes
  address_space       = var.vnet_address_space
}

module "public_ip" {
  source              = "./modules/public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "${var.public_ip_name}-${var.env}"
  allocation_method   = var.public_ip_allocation_method
}

module "network_interface" {
  source                        = "./modules/network_interface"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  name                          = "${var.nic_name}-${var.env}"
  ip_config_name                = "${var.nic_name}-${var.nic_ip_config_name}-${var.env}"
  subnet_id                     = module.virtual_network.subnet_id
  public_ip_id                  = module.public_ip.Id
  private_ip_address_allocation = var.nic_private_ip_address_allocation
}

module "network_security_group" {
  source                   = "./modules/network_security_group"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  name                     = "${var.nsg_name}-${var.env}"
  subnet_id                = module.virtual_network.subnet_id
  whitelisted_ip_addresses = var.nsg_whitelisted_ip_addresses
  network_interface_id     = module.network_interface.id
}

module "key_vault" {
  source                          = "./modules/key_vault"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  name                            = "${var.kv_name}-${var.env}"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  object_id                       = data.azurerm_client_config.current.object_id
  storage_account_name            = module.storage_account.name
  virtual_network_subnet_ids      = [module.virtual_network.subnet_id]
  sku_name                        = var.kv_sku_name
  enabled_for_deployment          = var.kv_enabled_for_deployment
  enabled_for_disk_encryption     = var.kv_enabled_for_disk_encryption
  enabled_for_template_deployment = var.kv_enabled_for_template_deployment
  enable_rbac_authorization       = var.kv_enable_rbac_authorization
  purge_protection_enabled        = var.kv_purge_protection_enabled
  soft_delete_retention_days      = var.kv_soft_delete_retention_days
  bypass                          = var.kv_bypass
  default_action                  = var.kv_default_action
  tags                            = var.tags
}

module "mssql_server" {
  source                       = "./modules/mssql_server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  sql_server_name              = "${var.sql_server_name}-${var.env}"
  sql_database_name            = "${var.sql_database_name}-${var.env}"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password
  tags                         = var.tags
}

module "service_plan" {
  source              = "./modules/service_plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "${var.sp_name}-${var.env}"
  sku_name            = var.sp_sku_name
  os_type             = "Windows" 
}

module "user_assigned_identity" {
  source              = "./modules/user_assigned_identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = var.uai_name
}

module "webapp_kv_access_policy" {
  source            = "./modules/keyvault_access_policy"
  kv_id             = module.key_vault.id
  tenant_id         = data.azurerm_client_config.current.tenant_id
  object_id         = module.user_assigned_identity.principal_id
  secret_permission = ["Get", "List"]
}

# Key Vault Secrets

module "connectionString_database" {
  source = "./modules/key_vault_secret"
  name   = "ConnectionStrings-reservicoDbConnection"
  value  = var.connectionString_database
  kv_id  = module.key_vault.id
}

module "connectionString_blob" {
  source = "./modules/key_vault_secret"
  name   = "ConnectionStrings-azureBlobStorage"
  value  = var.connectionString_blob
  kv_id  = module.key_vault.id
}

module "emailConfig_Password" {
  source = "./modules/key_vault_secret"
  name   = "emailConfig-Password"
  value  = var.emailConfig_Password
  kv_id  = module.key_vault.id
}

module "emailConfig_ApplicationUrl" {
  source = "./modules/key_vault_secret"
  name   = "emailConfig-ApplicationUrl"
  value  = var.emailConfig_ApplicationUrl
  kv_id  = module.key_vault.id
}

module "emailConfig_PublicApplicationUrl" {
  source = "./modules/key_vault_secret"
  name   = "emailConfig-PublicApplicationUrl"
  value  = var.emailConfig_PublicApplicationUrl
  kv_id  = module.key_vault.id
}

module "identityAuthConfig_TokenIssuer" {
  source = "./modules/key_vault_secret"
  name   = "identityAuthConfig-TokenIssuer"
  value  = var.identityAuthConfig_TokenIssuer
  kv_id  = module.key_vault.id
}

module "identityAuthConfig_TokenSalt" {
  source = "./modules/key_vault_secret"
  name   = "identityAuthConfig-TokenSalt"
  value  = var.identityAuthConfig_TokenSalt
  kv_id  = module.key_vault.id
}

module "identityAuthConfig_ClientCredentials_ClientId" {
  source = "./modules/key_vault_secret"
  name   = "identityAuthConfig-ClientCredentials-ClientId"
  value  = var.identityAuthConfig_ClientCredentials_ClientId
  kv_id  = module.key_vault.id
}

module "identityAuthConfig_ClientCredentials_ClientSecret" {
  source = "./modules/key_vault_secret"
  name   = "identityAuthConfig-ClientCredentials-ClientSecret"
  value  = var.identityAuthConfig_ClientCredentials_ClientSecret
  kv_id  = module.key_vault.id
}

# End Key Vault Secrets

module "windows_dotnet_web_app" {
  source                          = "./modules/windows_dotnet_web_app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  name                            = "${var.wdnwa_name}-${var.env}"
  service_plan_id                 = module.service_plan.id
  uai_ids                         = [module.user_assigned_identity.id]
  key_vault_reference_identity_id = module.user_assigned_identity.id

  app_settings = {
    ASPNETCORE_ENVIRONMENT                                       = var.aspnetcore_env,
    ConnectionStrings__reservicoDbConnection                     = "@Microsoft.KeyVault(SecretUri=${module.connectionString_database.versionless_id})",
    ConnectionStrings__azureBlobStorage                          = "@Microsoft.KeyVault(SecretUri=${module.connectionString_blob.versionless_id})",
    EmailConfig__Password                                        = "@Microsoft.KeyVault(SecretUri=${module.emailConfig_Password.versionless_id})",
    EmailConfig__ApplicationUrl                                  = "@Microsoft.KeyVault(SecretUri=${module.emailConfig_ApplicationUrl.versionless_id})",
    EmailConfig__PublicApplicationUrl                            = "@Microsoft.KeyVault(SecretUri=${module.emailConfig_PublicApplicationUrl.versionless_id})",
    IdentityAuthorizationConfig__TokenIssuer                     = "@Microsoft.KeyVault(SecretUri=${module.identityAuthConfig_TokenIssuer.versionless_id})",
    IdentityAuthorizationConfig__TokenSalt                       = "@Microsoft.KeyVault(SecretUri=${module.identityAuthConfig_TokenSalt.versionless_id})",
    IdentityAuthorizationConfig__ClientCredentials__ClientId     = "@Microsoft.KeyVault(SecretUri=${module.identityAuthConfig_ClientCredentials_ClientId.versionless_id})",
    IdentityAuthorizationConfig__ClientCredentials__ClientSecret = "@Microsoft.KeyVault(SecretUri=${module.identityAuthConfig_ClientCredentials_ClientSecret.versionless_id})",
  }
}

module "service_plan_linux" {
  source              = "./modules/service_plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "${var.sp_name}-linux-${var.env}"
  sku_name            = var.sp_sku_name
  os_type             = "Linux"
}

module "linux_nodejs_bo_web_app" {
  source                          = "./modules/linux_nodejs_web_app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  name                            = "${var.wnjwa_bo_name}-${var.env}"
  service_plan_id                 = module.service_plan_linux.id
  uai_ids                         = [module.user_assigned_identity.id]
  key_vault_reference_identity_id = module.user_assigned_identity.id

  app_settings = {}
}

module "linux_nodejs_front_web_app" {
  source                          = "./modules/linux_nodejs_web_app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  name                            = "${var.wnjwa_front_name}-${var.env}"
  service_plan_id                 = module.service_plan_linux.id
  uai_ids                         = [module.user_assigned_identity.id]
  key_vault_reference_identity_id = module.user_assigned_identity.id

  app_settings = {}
}

module "linux_nodejs_public_web_app" {
  source                          = "./modules/linux_nodejs_web_app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  name                            = "${var.wnjwa_public_name}-${var.env}"
  service_plan_id                 = module.service_plan_linux.id
  uai_ids                         = [module.user_assigned_identity.id]
  key_vault_reference_identity_id = module.user_assigned_identity.id

  app_settings = {}
}