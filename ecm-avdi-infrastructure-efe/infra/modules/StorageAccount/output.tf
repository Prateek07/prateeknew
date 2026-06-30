output "storageAccount" {
  description = "Map of Storage Accounts."
  value       = azurerm_storage_account.storageAccount
  sensitive   = true
}
 
# output "storageAccountIds" {
#   description = "Storage Account IDs by key."
#   value       = { for key, value in azurerm_storage_account.storageAccount : key => value.id }
# }
 
# output "storageAccountNames" {
#   description = "Storage Account names by key."
#   value       = { for key, value in azurerm_storage_account.storageAccount : key => value.name }
# }
 
# output "storageAccountPrimaryAccessKeys" {
#   description = "Storage Account primary access keys by key."
#   value       = { for key, value in azurerm_storage_account.storageAccount : key => value.primary_access_key }
#   sensitive   = true
# }


 