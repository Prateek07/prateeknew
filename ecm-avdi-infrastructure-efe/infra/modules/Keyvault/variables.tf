
variable "keyVaultVariables" {
  description = "Map of Key Vaults to create."
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    sku_name                      = optional(string, "standard")
    purge_protection_enabled      = optional(bool, true)
    soft_delete_retention_days    = optional(number, 90)
    public_network_access_enabled = optional(bool, true)
    enabled_for_disk_encryption   = optional(bool, false)
    rbac_authorization_enabled     = optional(bool, true)
    tags                          = optional(map(string), {})
 
    access_policies = optional(map(object({
      object_id               = string
      key_permissions         = optional(list(string), [])
      secret_permissions      = optional(list(string), [])
      certificate_permissions = optional(list(string), [])
      storage_permissions     = optional(list(string), [])
    })), {})
  }))
  default = {}
}
# variable "commonTags" {
#   description = "Tags applied to all resources (merged with per-object tags)."
#   type        = map(string)
#   default     = {}
# }
 

