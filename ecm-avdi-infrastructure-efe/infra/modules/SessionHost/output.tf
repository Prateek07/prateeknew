output "sessionHost" {
  description = "Map of session host VMs created."
  value       = azurerm_windows_virtual_machine.avd_vm
}
output "hostpoolRegistrationInfo" {
  description = "Host pool registration info by host pool key."
  value       = azurerm_virtual_desktop_host_pool_registration_info.rg_token
}