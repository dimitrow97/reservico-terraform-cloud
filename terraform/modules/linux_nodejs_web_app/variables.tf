variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the web app"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the web app"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the web app"
  type        = string
}

variable "service_plan_id" {
  description = "(Required) Specifies the service plan id for the web app"
  type        = string
}

variable "key_vault_reference_identity_id" {
  description = "(Optional) The User Assigned Identity ID used for accessing KeyVault secrets"
  type        = string
}

variable "uai_ids" {
  description = "(Required) Specifies the user assigned identities for the web app"
  type = list(string)
}

variable "app_settings" {
  description = "(Optional) Specifies the app settings for the web app"
  type = map(string)
}