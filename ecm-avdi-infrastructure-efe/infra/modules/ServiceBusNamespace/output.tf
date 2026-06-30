output "serviceBusNamespace" {
  description = "Map of Service Bus namespaces."
  value       = azurerm_servicebus_namespace.serviceBusNamespace
}
 
output "serviceBusNamespaceIds" {
  description = "Service Bus namespace IDs by key."
  value       = { for key, value in azurerm_servicebus_namespace.serviceBusNamespace : key => value.id }
}
 
output "serviceBusNamespaceNames" {
  description = "Service Bus namespace names by key."
  value       = { for key, value in azurerm_servicebus_namespace.serviceBusNamespace : key => value.name }
}