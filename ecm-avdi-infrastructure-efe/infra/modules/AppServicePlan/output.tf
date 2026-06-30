output "appServicePlan" {
  description = "Map of App Service Plans."
  value       = azurerm_service_plan.appServicePlan
}
 
output "appServicePlanIds" {
  description = "App Service Plan IDs by key."
  value       = { for key, value in azurerm_service_plan.appServicePlan : key => value.id }
}
 
output "appServicePlanNames" {
  description = "App Service Plan names by key."
  value       = { for key, value in azurerm_service_plan.appServicePlan : key => value.name }
}