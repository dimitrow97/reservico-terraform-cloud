variable "env" {
  description = "Specifies the environment"
  default     = "dev"
  type        = string
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "West Europe"
  type        = string
}

variable "resource_grp_name" {
  description = "Specifies the resource group name"
  default     = "cub-rg-001"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    createdWith = "Terraform"
  }
}

# Storage Account

variable "storage_account_name" {
  description = "(Required) Specifies the name of the storage account"
  type        = string
}

variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  default     = "StorageV2"
  type        = string

   validation {
    condition = contains(["Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  default     = "Standard"
  type        = string

   validation {
    condition = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}

variable "storage_account_replication_type" {
  description = "(Optional) Specifies the replication type of the storage account"
  default     = "LRS"
  type        = string

  validation {
    condition = contains(["LRS", "ZRS", "GRS", "GZRS", "RA-GRS", "RA-GZRS"], var.storage_account_replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}

variable "storage_account_is_hns_enabled" {
  description = "(Optional) Specifies the replication type of the storage account"
  default     = false
  type        = bool
}

variable "storage_account_default_action" {
    description = "Allow or disallow public access to all blobs or containers in the storage accounts. The default interpretation is true for this property."
    default     = "Allow"
    type        = string  
}

variable "storage_account_ip_rules" {
    description = "Specifies IP rules for the storage account"
    default     = []
    type        = list(string)  
}

variable "storage_account_identity_type" {
  description = "(Required) Specifies the type of the identity of the storage account"
  type        = string
  default     = "SystemAssigned"
}

# Blob Storage

variable "blob_storage_name" {
  description = "(Required) Specifies the name of the blob storage"
  type        = string
}

variable "blob_storage_access_type" {
  description = "(Optional) Specifies the access type of the blob storage"
  default     = "blob"
  type        = string
}

# Virtual Network

variable "vnet_name" {
  type        = string
  description = "(Required) Specifies the name of the virtual network"
}

variable "vnet_subnet_name" {
  type        = string
  description = "(Required) Specifies the name of the sub network"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "(Required) Specifies the address space of the virtual network"
}

variable "vnet_address_prefixes" {
  type        = list(string)
  description = "(Required) Specifies the address prefixes of the sub network"
}

# Key Vault

variable "kv_name" {
  description = "(Required) Specifies the name of the key vault"
  type        = string
}

variable "kv_disk_encryption" {
  description = "(Required) Specifies if the key vault has enabled disk encryption"
  type        = bool
  default     = true
}

variable "kv_sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"

  validation {
    condition = contains(["standard", "premium" ], var.kv_sku_name)
    error_message = "The value of the sku name property of the key vault is invalid."
  }
}

variable "kv_enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false."
  type        = bool
  default     = false
}

variable "kv_enabled_for_disk_encryption" {
  description = " (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
  type        = bool
  default     = false
}

variable "kv_enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false."
  type        = bool
  default     = false
}

variable "kv_enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false."
  type        = bool
  default     = false
}

variable "kv_purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
  type        = bool
  default     = false
}

variable "kv_soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 7
}

variable "kv_bypass" { 
  description = "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
  type        = string
  default     = "AzureServices" 

  validation {
    condition = contains(["AzureServices", "None" ], var.kv_bypass)
    error_message = "The valut of the bypass property of the key vault is invalid."
  }
}

variable "kv_default_action" { 
  description = "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Allow" 

  validation {
    condition = contains(["Allow", "Deny" ], var.kv_default_action)
    error_message = "The value of the default action property of the key vault is invalid."
  }
}

variable "kv_ip_rules" { 
  description = "(Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
  default     = []
}

# Public IP

variable "public_ip_name" {
  type        = string
  description = "(Required) Specifies the name of the public ip"
}

variable "public_ip_allocation_method" {
  type        = string
  description = "(Required) Specifies the allocation method of the public ip"
  default     = "Dynamic"
}

# Network Interface

variable "nic_name" {
  type        = string
  description = "(Required) Specifies the name of the network interface"
}

variable "nic_ip_config_name" {
  type        = string
  description = "(Required) Specifies the name of the ip configuration for the network interface"
}

variable "nic_private_ip_address_allocation" {
  type        = string
  description = "(Required) Specifies the private ip address allocation of the ip configuration for the network interface"
  default     = "Dynamic"
}

# Network Security Group

variable "nsg_name" {
  description = "(Required) Specifies the name of the network security group"
  type        = string
}

variable "nsg_whitelisted_ip_addresses" {
  description = "(Required) Specifies the list of whitelisted IP Addresses for the network security group"
  type        = list(string)
}

# SQL Server and SQL Database

variable "sql_server_name" {
  description = "(Required) Specifies the name of the sql server"
  type        = string
}

variable "sql_database_name" {
  description = "(Required) Specifies the name of the sql database"
  type        = string
}

variable "sql_administrator_login" {
  description = "(Required) Specifies the login for the admin account in the sql server"
  type        = string
}

variable "sql_administrator_login_password" {
  description = "(Required) Specifies the login password for the admin account in the sql server"
  type        = string
}

# Service Plan

variable "sp_name" {
  description = "(Required) Specifies the name of the service plan"
  type        = string
}


variable "sp_sku_name" {
  description = "(Required) Specifies the sku name of the service plan"
  type        = string
  default     = "F1"
}

# User Assigned Identity

variable "uai_name" {
  description = "(Required) Specifies the name of the user assigned identity"
  type        = string
}

# Windows .Net Web App

variable "wdnwa_name" {
  description = "(Required) Specifies the name of the web app"
  type        = string
}

variable "aspnetcore_env" {
  description = "(Required) Specifies the env variable used to get the correct appSettings.json file for the web app"
  type        = string
}

# Windows NodeJS Web App

variable "wnjwa_bo_name" {
  description = "(Required) Specifies the name of the web app"
  type        = string
}

variable "wnjwa_front_name" {
  description = "(Required) Specifies the name of the web app"
  type        = string
}

variable "wnjwa_public_name" {
  description = "(Required) Specifies the name of the web app"
  type        = string
}
# Windows .Net Web App KeyVault Secrets

## Connection Strings
variable "connectionString_database" {
  description = "(Required) Specifies the connectionString for the database of the web app"
  type        = string
}

variable "connectionString_blob" {
  description = "(Required) Specifies the connectionString for the blob of the web app"
  type        = string
}

## Email Config
variable "emailConfig_Password" {
  description = "(Required) Specifies the password for the email config of the web app"
  type        = string
}

variable "emailConfig_ApplicationUrl" {
  description = "(Required) Specifies the client app url for the email config of the web app"
  type        = string
}

variable "emailConfig_PublicApplicationUrl" {
  description = "(Required) Specifies the public app url for the email config of the web app"
  type        = string
}

## Identity Authorization Config

variable "identityAuthConfig_TokenIssuer" {
  description = "(Required) Specifies the Token Issuer for the identity auth config of the web app"
  type        = string
}

variable "identityAuthConfig_TokenSalt" {
  description = "(Required) Specifies the Token Issuer for the identity auth config of the web app"
  type        = string
}

variable "identityAuthConfig_ClientCredentials_ClientId" {
  description = "(Required) Specifies the Client Id for the client credentials in the identity auth config of the web app"
  type        = string
}

variable "identityAuthConfig_ClientCredentials_ClientSecret" {
  description = "(Required) Specifies the Client Secret for the client credentials in the identity auth config of the web app"
  type        = string
}