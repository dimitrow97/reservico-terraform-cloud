output "fully_qualified_domain_name" {
    description = "Specifies the fully qualified domain name of the sql server"
    value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}