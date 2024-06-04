output "web_app_identity_principal_id" {
    description = "Specifies the principal_id of the app identity"
    value       = azurerm_windows_web_app.windows_dotnet_web_app.identity[0].principal_id
}