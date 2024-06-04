output "versionless_id" {
    description = "Specifies the versionless id of the key vault secret"
    value       = azurerm_key_vault_secret.keyvault_secret.versionless_id
}