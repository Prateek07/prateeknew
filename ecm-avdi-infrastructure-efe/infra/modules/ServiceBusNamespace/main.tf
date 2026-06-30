resource "azurerm_servicebus_namespace" "serviceBusNamespace" {
  for_each = var.serviceBusNamespaceVariables
 
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku                           = try(each.value.sku, "Standard")
  capacity                      = try(each.value.capacity, null)
  premium_messaging_partitions  = try(each.value.premium_messaging_partitions, null)
  minimum_tls_version           = try(each.value.minimum_tls_version, "1.2")
  local_auth_enabled            = try(each.value.local_auth_enabled, true)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)
 
  dynamic "identity" {
    for_each = try(each.value.identity_type, null) != null || length(try(each.value.identity_ids, [])) > 0 ? [1] : []
    content {
      type         = coalesce(try(each.value.identity_type, null), length(try(each.value.identity_ids, [])) > 0 ? "UserAssigned" : "SystemAssigned")
      identity_ids = length(try(each.value.identity_ids, [])) > 0 ? each.value.identity_ids : null
    }
  }
 
  dynamic "customer_managed_key" {
    for_each = try(each.value.customer_managed_key, null) == null ? [] : [each.value.customer_managed_key]
    content {
      key_vault_key_id                  = customer_managed_key.value.key_vault_key_id
      identity_id                       = customer_managed_key.value.identity_id
      infrastructure_encryption_enabled = try(customer_managed_key.value.infrastructure_encryption_enabled, null)
    }
  }
 
  dynamic "network_rule_set" {
    for_each = try(each.value.network_rule_set, null) == null ? [] : [each.value.network_rule_set]
    content {
      default_action                = try(network_rule_set.value.default_action, "Allow")
      public_network_access_enabled = try(network_rule_set.value.public_network_access_enabled, true)
      trusted_services_allowed      = try(network_rule_set.value.trusted_services_allowed, null)
      ip_rules                      = try(network_rule_set.value.ip_rules, [])
 
      dynamic "network_rules" {
        for_each = try(network_rule_set.value.network_rules, [])
        content {
          subnet_id                            = network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = try(network_rules.value.ignore_missing_vnet_service_endpoint, false)
        }
      }
    }
  }
 
  dynamic "timeouts" {
    for_each = try(each.value.timeouts, null) == null ? [] : [each.value.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
 
  tags = try(each.value.tags, {})
 
  lifecycle {
    prevent_destroy = true
  }
}
