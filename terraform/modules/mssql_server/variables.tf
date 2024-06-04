variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the sql server"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the sql server"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the sql server"
  default     = {}
}

variable "sql_server_name" {
  description = "(Required) Specifies the name of the sql server"
  type        = string
}

variable "sql_database_name" {
  description = "(Required) Specifies the name of the sql database"
  type        = string
}

variable "administrator_login" {
  description = "(Required) Specifies the login for the admin account in the sql server"
  type        = string
}

variable "administrator_login_password" {
  description = "(Required) Specifies the login password for the admin account in the sql server"
  type        = string
}