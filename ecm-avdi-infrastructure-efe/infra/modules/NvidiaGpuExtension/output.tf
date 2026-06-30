output "nvidia_gpu_driver_extension" {
  description = "NVIDIA GPU driver VM extension resource."
  value       = azurerm_virtual_machine_extension.nvidia_gpu_driver
}