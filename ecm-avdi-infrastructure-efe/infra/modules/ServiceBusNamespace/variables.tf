variable "serviceBusNamespaceVariables" {
  description = "Map of Service Bus namespaces. Optional attributes are exposed in the same style as SessionHost."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    capacity                      = optional(number)
    premium_messaging_partitions  = optional(number)
    minimum_tls_version           = optional(string, "1.2")
    local_auth_enabled            = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
 
    identity_type = optional(string)
    identity_ids  = optional(list(string), [])
 
    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      identity_id                       = string
      infrastructure_encryption_enabled = optional(bool)
    }))
 
    network_rule_set = optional(object({
      default_action                = optional(string, "Allow")
      public_network_access_enabled = optional(bool, true)
      trusted_services_allowed      = optional(bool)
      ip_rules                      = optional(list(string), [])
      network_rules = optional(list(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      })), [])
    }))
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}