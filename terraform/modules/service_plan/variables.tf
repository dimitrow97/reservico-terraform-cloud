variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the service plan"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the service plan"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the service plan"
  type        = string
}

variable "sku_name" {
  description = "(Required) Specifies the sku name of the service plan"
  type        = string
  default     = "F1"
}

variable "os_type" {
  description = "(Required) Specifies the OS type of the service plan"
  type        = string
}