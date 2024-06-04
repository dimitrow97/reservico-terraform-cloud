variable "kv_id" {
  description = "(Required) Specifies the key vault id for the kv access policy"
  type        = string
}

variable "tenant_id" {
  description = "(Required) Specifies the tenant id for the kv access policy"
  type        = string
}

variable "object_id" {
  description = "(Required) Specifies the object id for the kv access policy"
  type        = string
}

variable "secret_permission" {
  description = "(Required) Specifies the secret permissions for the kv access policy"
  type        = list(string)
  default = [ "Get" ]
}