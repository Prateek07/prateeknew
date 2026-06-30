variable "storageAccountVariables" {
  description = "Map of Storage Accounts. Used here for the Windows Function App backing storage."
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    account_kind                    = optional(string, "StorageV2")
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    access_tier                     = optional(string, "Hot")
    min_tls_version                 = optional(string, "TLS1_2")
    https_traffic_only_enabled      = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    shared_access_key_enabled       = optional(bool, true)
    public_network_access_enabled   = optional(bool, true)
    tags                            = optional(map(string), {})
  }))
  default = {}
}