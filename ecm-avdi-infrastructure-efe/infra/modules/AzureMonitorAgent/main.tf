# Installs the Azure Monitor Agent (AMA) extension on session host virtual machines.

# Use this module when VMs need to send monitoring data to Azure Monitor through Data Collection Rules (DCRs).

terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}
 
resource "azurerm_virtual_machine_extension" "ama" {
  for_each = var.vm_ids
 
  name                       = "${each.key}-ama"
  virtual_machine_id         = each.value
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.22"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled    = false
  provision_after_extensions  = []
 
  tags = merge(var.commonTags, try(each.value.tags, {}))
  lifecycle {
    ignore_changes = all 
  }
}
 
resource "time_sleep" "wait_for_vm_after_start" {
  for_each = var.vm_ids
 
  destroy_duration = "90s"
 
  depends_on = [
    azurerm_virtual_machine_extension.ama
  ]
    lifecycle {
    ignore_changes = all 
  }
}
 
resource "azapi_resource_action" "start_vm_before_ama_destroy" {
  for_each    = var.vm_ids
  type        = "Microsoft.Compute/virtualMachines@2023-09-01"
  resource_id = each.value
  action      = "start"
  method      = "POST"
  when        = "destroy"
 
  depends_on = [
    time_sleep.wait_for_vm_after_start
  ]
  lifecycle {
    ignore_changes = all 
  }
}
 
 

# terraform {
#   required_providers {
#     azapi = {
#       source = "Azure/azapi"
#     }
#     time = {
#       source = "hashicorp/time"
#     }
#     null = {
#       source = "hashicorp/null"
#     }
#   }
# }
 
# resource "azurerm_virtual_machine_extension" "ama" {
#   for_each = var.vm_ids
 
#   name                       = "${each.key}-ama"
#   virtual_machine_id         = each.value
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorWindowsAgent"
#   type_handler_version       = "1.22"
#   auto_upgrade_minor_version = true
 
#   tags = var.commonTags
# }
 
# resource "time_sleep" "wait_for_vm_after_start" {
#   for_each = var.vm_ids
 
#   destroy_duration = "90s"
 
#   depends_on = [
#     azurerm_virtual_machine_extension.ama
#   ]
# }
 
# resource "null_resource" "start_vm_before_ama_destroy" {
#   for_each = var.vm_ids
 
#   triggers = {
#     vm_id = each.value
#   }
 
#   provisioner "local-exec" {
#     when        = destroy
#     interpreter = ["PowerShell", "-Command"]
#     command     = <<-EOT
#       az vm start --ids "${self.triggers.vm_id}" 2>$null
#       exit 0
#     EOT
#   }
 
#   depends_on = [
#     time_sleep.wait_for_vm_after_start
#   ]
# }