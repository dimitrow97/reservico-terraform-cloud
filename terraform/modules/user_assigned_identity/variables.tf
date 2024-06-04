variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the user assigned identity"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the user assigned identity"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the user assigned identity"
  type        = string
}