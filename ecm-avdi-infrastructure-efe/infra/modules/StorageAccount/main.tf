resource "azurerm_storage_account" "storageAccount" {
  for_each = var.storageAccountVariables
 
  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  account_kind                    = try(each.value.account_kind, "StorageV2")
  account_tier                    = try(each.value.account_tier, "Standard")
  account_replication_type        = try(each.value.account_replication_type, "LRS")
  access_tier                     = try(each.value.access_tier, "Hot")
  min_tls_version                 = try(each.value.min_tls_version, "TLS1_2")
  https_traffic_only_enabled      = try(each.value.https_traffic_only_enabled, true)
  allow_nested_items_to_be_public = try(each.value.allow_nested_items_to_be_public, false)
  shared_access_key_enabled       = try(each.value.shared_access_key_enabled, true)
  public_network_access_enabled   = try(each.value.public_network_access_enabled, true)
 
  tags = try(each.value.tags, {})
 
  # lifecycle {
  #   prevent_destroy = true
  # }
}
