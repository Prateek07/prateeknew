output "mIdentity" {
  description = "Map of managed Identity"
  value       = azurerm_user_assigned_identity.mIdentity
}
 
output "managedIdentityIds" {
  description = "Managed Identity resource IDs by key."
  value       = { for key, value in azurerm_user_assigned_identity.mIdentity : key => value.id }
}
 
output "managedIdentityPrincipalIds" {
  description = "Managed Identity principal IDs by key."
  value       = { for key, value in azurerm_user_assigned_identity.mIdentity : key => value.principal_id }
}
 
output "managedIdentityClientIds" {
  description = "Managed Identity client IDs by key."
  value       = { for key, value in azurerm_user_assigned_identity.mIdentity : key => value.client_id }
}