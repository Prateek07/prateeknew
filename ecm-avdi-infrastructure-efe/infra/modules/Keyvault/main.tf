# This module creates Key Vaults in Azure which can be used to securely store and manage secrets, keys, and certificates for applications and services. The module allows for dynamic configuration of Key Vault properties such as SKU, access policies, and network access controls through the use of variables. 
data "azurerm_client_config" "current" {}
 
resource "azurerm_key_vault" "Keyvault" {
  for_each = var.keyVaultVariables
 
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = each.value.sku_name
  purge_protection_enabled      = try(each.value.purge_protection_enabled, true)
  soft_delete_retention_days    = try(each.value.soft_delete_retention_days, 90)
  public_network_access_enabled = try(each.value.public_network_access_enabled, false)
  enabled_for_disk_encryption   = try(each.value.enabled_for_disk_encryption, false)
  rbac_authorization_enabled     = try(each.value.rbac_authorization_enabled, true)
  dynamic "access_policy" {
    for_each = try(each.value.access_policies, {})
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value.object_id
 
      key_permissions         = try(access_policy.value.key_permissions, [])
      secret_permissions      = try(access_policy.value.secret_permissions, [])
      certificate_permissions = try(access_policy.value.certificate_permissions, [])
      storage_permissions     = try(access_policy.value.storage_permissions, [])
    }
  }
 
  tags = try(each.value.tags, {})
    lifecycle {
      ignore_changes = [tenant_id]
      prevent_destroy = true
  }
}
 
