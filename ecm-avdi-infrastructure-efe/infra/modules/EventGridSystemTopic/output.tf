output "eventGridSystemTopic" {
  description = "Map of Event Grid system topics."
  value       = azurerm_eventgrid_system_topic.eventGridSystemTopic
}
 
output "eventGridSystemTopicIds" {
  description = "Event Grid system topic IDs by key."
  value       = { for key, value in azurerm_eventgrid_system_topic.eventGridSystemTopic : key => value.id }
}
 
output "eventGridSystemTopicNames" {
  description = "Event Grid system topic names by key."
  value       = { for key, value in azurerm_eventgrid_system_topic.eventGridSystemTopic : key => value.name }
}
 
