output "principal_id" {
    description = "Specifies the principal_id of the user assigned identity"
    value       = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

output "id" {
    description = "Specifies the id of the user assigned identity"
    value       = azurerm_user_assigned_identity.user_assigned_identity.id
}