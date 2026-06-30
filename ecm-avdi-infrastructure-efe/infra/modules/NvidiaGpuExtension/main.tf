resource "azurerm_virtual_machine_extension" "nvidia_gpu_driver" {
  name                       = var.extension_name
  virtual_machine_id         = var.virtual_machine_id
  publisher            = "Microsoft.HpcCompute"
  type                 = "NvidiaGpuDriverWindows"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true
  settings = jsonencode({})
}



