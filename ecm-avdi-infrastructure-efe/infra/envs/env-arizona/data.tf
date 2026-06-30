data "azurerm_virtual_network" "vnet" {
  for_each = var.snetVariables
  name                = each.value.vnetname
  resource_group_name = each.value.vnetrg
}
data "azurerm_key_vault" "session_host" {
  for_each = {
    for key, value in var.sessionHostVariables : key => value
    if try(value.key_vault_key, null) != null
  }
 
  name                = var.keyVaultVariables[each.value.key_vault_key].name
  resource_group_name = var.keyVaultVariables[each.value.key_vault_key].resource_group_name
 
  depends_on = [
    # module.Keyvault
  ]
}
 
data "azurerm_key_vault_secret" "session_host_admin_username" {
  for_each = {
    for key, value in var.sessionHostVariables : key => value
    if try(value.admin_username, null) != null
  }
 
  name         = each.value.admin_username
  key_vault_id = data.azurerm_key_vault.session_host[each.key].id
}
 
data "azurerm_key_vault_secret" "session_host_admin_password" {
  for_each = {
    for key, value in var.sessionHostVariables : key => value
    if try(value.admin_password, null) != null
  }
 
  name         = each.value.admin_password
  key_vault_id = data.azurerm_key_vault.session_host[each.key].id
}
 
data "azurerm_key_vault_secret" "session_host_domain_join_username" {
  for_each = {
    for key, value in var.sessionHostVariables : key => value
    if try(value.domain_join_username, null) != null
  }
 
  name         = each.value.domain_join_username
  key_vault_id = data.azurerm_key_vault.session_host[each.key].id
}
 
data "azurerm_key_vault_secret" "session_host_domain_join_password" {
  for_each = {
    for key, value in var.sessionHostVariables : key => value
    if try(value.domain_join_password, null) != null
  }
 
  name         = each.value.domain_join_password
  key_vault_id = data.azurerm_key_vault.session_host[each.key].id
}