variable "hostpool_ids" {
  description = "Map of host pool ids"
  type        = map(string)
}
 
variable "sessionHosts" {
  description = "Map of session host definitions"
  type = map(object({
    vm_name                  = string
    location                 = string
    resource_group_name      = string
    vm_size                  = string
    admin_username           = string
    admin_password           = string
    network_interface_ids    = list(string)
 
    availability_set_id      = optional(string)
    capacity_reservation_group_id = optional(string)
    computer_name            = optional(string)
    custom_data              = optional(string)
    dedicated_host_group_id  = optional(string)
    dedicated_host_id        = optional(string)
    edge_zone                = optional(string)
    encryption_at_host_enabled = optional(bool)
    eviction_policy          = optional(string)
    extensions_time_budget   = optional(string)
    hotpatching_enabled      = optional(bool)
    license_type             = optional(string)
    max_bid_price            = optional(number)
    patch_assessment_mode    = optional(string)
    patch_mode               = optional(string)
    platform_fault_domain    = optional(number)
    priority                 = optional(string)
    provision_vm_agent       = optional(bool)
    proximity_placement_group_id = optional(string)
    secure_boot_enabled      = optional(bool)
    user_data                = optional(string)
    virtual_machine_scale_set_id = optional(string)
    vtpm_enabled             = optional(bool)
    zone                     = optional(string)
    allow_extension_operations = optional(bool)
    bypass_platform_safety_checks_on_user_schedule_enabled = optional(bool)
    reboot_setting           = optional(string)
 
    os_disk_caching                   = optional(string)
    os_disk_storage_account_type      = optional(string)
    disk_size_gb                      = optional(number)
    os_disk_name                      = optional(string)
    os_disk_write_accelerator_enabled = optional(bool)
    os_disk_disk_encryption_set_id    = optional(string)
    os_disk_security_encryption_type  = optional(string)
 
    source_image_id = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string)
    }))
 
    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool)
    }))
 
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
 
    identity_type = optional(string)
    identity_ids  = optional(list(string))
 
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
 
    secrets = optional(list(object({
      key_vault_id = string
      certificates = optional(list(object({
        store = string
        url   = string
      })), [])
    })), [])
 
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }))
 
    winrm_listeners = optional(list(object({
      protocol        = string
      certificate_url = optional(string)
    })), [])
 
    domain_name          = string
    domain_join_username = string
    domain_join_password = string
    ou_path              = optional(string)
 
    hostpool_name        = string
    hostpool_key         = string
    enable_nvidia_gpu_driver = optional(bool, false)
    tags                 = optional(map(string), {})
  }))
}