output "serviceBusQueue" {
  description = "Map of Service Bus queues."
  value       = azurerm_servicebus_queue.serviceBusQueue
}
 
output "serviceBusQueueIds" {
  description = "Service Bus queue IDs by key."
  value       = { for key, value in azurerm_servicebus_queue.serviceBusQueue : key => value.id }
}
 
output "serviceBusQueueNames" {
  description = "Service Bus queue names by key."
  value       = { for key, value in azurerm_servicebus_queue.serviceBusQueue : key => value.name }
}
 