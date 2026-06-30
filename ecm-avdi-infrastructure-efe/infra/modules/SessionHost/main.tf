#registration info is needed to generate the token for session host registration with the host pool. 
# The token is valid for 48 hours and will be ignored for changes to expiration date to prevent unnecessary re-registration of session hosts.
resource "azurerm_virtual_desktop_host_pool_registration_info" "rg_token" {
  for_each = var.hostpool_ids
 
  hostpool_id     = each.value
  expiration_date = timeadd(timestamp(), "48h")
 
  lifecycle {
    ignore_changes = [expiration_date]
  }
}
# Session Hosts must be created after the host pool registration info to ensure the token is available for DSC extension during VM provisioning, and must be unregistered before the host pool is deleted to prevent orphaned session hosts.
resource "azurerm_windows_virtual_machine" "avd_vm" {
  for_each = var.sessionHosts
 
  name                            = each.value.vm_name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  size                            = each.value.vm_size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  network_interface_ids           = each.value.network_interface_ids
  availability_set_id             = try(each.value.availability_set_id, null)
  capacity_reservation_group_id   = try(each.value.capacity_reservation_group_id, null)
  computer_name                   = try(each.value.computer_name, null)
  custom_data                     = try(each.value.custom_data, null)
  dedicated_host_group_id         = try(each.value.dedicated_host_group_id, null)
  dedicated_host_id               = try(each.value.dedicated_host_id, null)
  edge_zone                       = try(each.value.edge_zone, null)
  encryption_at_host_enabled      = try(each.value.encryption_at_host_enabled, null)
  eviction_policy                 = try(each.value.eviction_policy, null)
  extensions_time_budget          = try(each.value.extensions_time_budget, null)
  hotpatching_enabled             = try(each.value.hotpatching_enabled, null)
  license_type                    = try(each.value.license_type, null)
  max_bid_price                   = try(each.value.max_bid_price, null)
  patch_assessment_mode           = try(each.value.patch_assessment_mode, null)
  patch_mode                      = try(each.value.patch_mode, null)
  platform_fault_domain           = try(each.value.platform_fault_domain, null)
  priority                        = try(each.value.priority, null)
  provision_vm_agent              = try(each.value.provision_vm_agent, true)
  proximity_placement_group_id    = try(each.value.proximity_placement_group_id, null)
  secure_boot_enabled             = try(each.value.secure_boot_enabled, null)
  user_data                       = try(each.value.user_data, null)
  virtual_machine_scale_set_id    = try(each.value.virtual_machine_scale_set_id, null)
  vtpm_enabled                    = try(each.value.vtpm_enabled, null)
  zone                            = try(each.value.zone, null)
  allow_extension_operations      = try(each.value.allow_extension_operations, true)
  bypass_platform_safety_checks_on_user_schedule_enabled = try(each.value.bypass_platform_safety_checks_on_user_schedule_enabled, null)
  reboot_setting                  = try(each.value.reboot_setting, null)
 
  os_disk {
    caching                   = coalesce(try(each.value.os_disk_caching, null), "ReadWrite")
    storage_account_type      = coalesce(try(each.value.os_disk_storage_account_type, null), "Premium_LRS")
    disk_size_gb    = try(each.value.disk_size_gb, null)
    name                      = try(each.value.os_disk_name, null)
    write_accelerator_enabled = try(each.value.os_disk_write_accelerator_enabled, null)
    disk_encryption_set_id    = try(each.value.os_disk_disk_encryption_set_id, null)
    security_encryption_type  = try(each.value.os_disk_security_encryption_type, null)
  }
 
  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_id, null) == null ? [1] : []
    content {
      publisher = each.value.source_image_reference.publisher
      offer     = each.value.source_image_reference.offer
      sku       = each.value.source_image_reference.sku
      version   = try(each.value.source_image_reference.version, "latest")
    }
  }
 
  source_image_id = try(each.value.source_image_id, null)
 
  dynamic "additional_capabilities" {
    for_each = try(each.value.additional_capabilities, null) == null ? [] : [each.value.additional_capabilities]
    content {
      ultra_ssd_enabled = try(additional_capabilities.value.ultra_ssd_enabled, null)
    }
  }
 
  dynamic "boot_diagnostics" {
    for_each = try(each.value.boot_diagnostics, null) == null ? [] : [each.value.boot_diagnostics]
    content {
      storage_account_uri = try(boot_diagnostics.value.storage_account_uri, null)
    }
  }
 
  identity {
    type         = coalesce(try(each.value.identity_type, null), "SystemAssigned")
    identity_ids = try(each.value.identity_ids, null)
  }
 
  dynamic "plan" {
    for_each = try(each.value.plan, null) == null ? [] : [each.value.plan]
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }
 
  dynamic "secret" {
    for_each = try(each.value.secrets, [])
    content {
      key_vault_id = secret.value.key_vault_id
 
      dynamic "certificate" {
        for_each = try(secret.value.certificates, [])
        content {
          store = certificate.value.store
          url   = certificate.value.url
        }
      }
    }
  }
 
  dynamic "termination_notification" {
    for_each = try(each.value.termination_notification, null) == null ? [] : [each.value.termination_notification]
    content {
      enabled = termination_notification.value.enabled
      timeout = try(termination_notification.value.timeout, null)
    }
  }
 
  dynamic "winrm_listener" {
    for_each = try(each.value.winrm_listeners, [])
    content {
      protocol        = winrm_listener.value.protocol
      certificate_url = try(winrm_listener.value.certificate_url, null)
    }
  }
 
  tags =  try(each.value.tags, {})

  lifecycle {
     ignore_changes = [tags]
  }
}
# extending os disk if specified to ensure session hosts meet minimum requirements for AVD. This will be done before domain join to prevent issues with domain join failure due to insufficient disk space.
resource "azurerm_virtual_machine_extension" "extend_os_disk" {
  for_each = {
    for k, v in var.sessionHosts : k => v
    if try(v.disk_size_gb, null) != null
  }
  name                       = "${each.value.vm_name}-extend-c-drive"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Bypass -Command \"$max = (Get-PartitionSupportedSize -DriveLetter C).SizeMax; Resize-Partition -DriveLetter C -Size $max\""
  })
    automatic_upgrade_enabled   = false
  provision_after_extensions   = []
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm
  ]
  lifecycle {
     ignore_changes = [
       settings,
       protected_settings
     ]
  }
} 
# Domain join must be done before DSC extension which configures session host registration with the host pool, and will fail if the VM is not domain joined.
resource "azurerm_virtual_machine_extension" "domain_join" {
  for_each = var.sessionHosts
 
  name                       = "${each.value.vm_name}-domainjoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
 
  settings = jsonencode({
    Name    = each.value.domain_name
    OUPath  = try(each.value.ou_path, null)
    User    = "${each.value.domain_name}\\${each.value.domain_join_username}"
    Restart = "true"
    Options = 3
  })
  automatic_upgrade_enabled   = false
  provision_after_extensions   = []

  protected_settings = jsonencode({
    Password = each.value.domain_join_password
  })
    depends_on = [
     azurerm_virtual_machine_extension.extend_os_disk
  ]
  lifecycle {
    ignore_changes = [
      settings,
      protected_settings
    ]
  }
}
#  DSC extension is used to register session hosts with the host pool during provisioning using the token generated from the host pool registration info resource. This ensures session hosts are registered and available in the host pool immediately after provisioning without requiring a separate registration step, and allows for dynamic configuration of session host registration properties through the use of variables and DSC configuration.
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  for_each = var.sessionHosts
 
  name                       = "${each.value.vm_name}-avd-dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
 
  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.usgovcloudapi.net/galleryartifacts/Configuration_1.0.02714.342.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
 
    properties = {
      hostPoolName          = each.value.hostpool_name
      registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.rg_token[each.value.hostpool_key].token
    }
  })
 
  lifecycle {
     ignore_changes = [
       settings,
       protected_settings
     ]
  }
 
  depends_on = [
    azurerm_virtual_machine_extension.domain_join, azurerm_virtual_machine_extension.extend_os_disk
  ]
}
module "NvidiaGpuDriverExtension" {
  source = "../NvidiaGpuExtension"
  for_each = {
    for k, v in var.sessionHosts : k => v
    if try(v.enable_nvidia_gpu_driver, false) == true
  }
  extension_name     = "nvidia-gpu-driver"
  virtual_machine_id = azurerm_windows_virtual_machine.avd_vm[each.key].id
  depends_on = [
     azurerm_virtual_machine_extension.domain_join, azurerm_virtual_machine_extension.extend_os_disk,azurerm_virtual_machine_extension.vmext_dsc
  ]
}
 