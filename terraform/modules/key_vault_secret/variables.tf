variable "name" {
  description = "(Required) Specifies the name for the kv secter"
  type        = string
}

variable "value" {
  description = "(Required) Specifies the value for the kv secret"
  type        = string
}

variable "kv_id" {
  description = "(Required) Specifies the key vault id for the kv secret"
  type        = string
}