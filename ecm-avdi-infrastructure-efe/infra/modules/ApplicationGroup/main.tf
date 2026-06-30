# Creates Azure Virtual Desktop (AVD) application groups and attaches them to existing host pools.
# Use of this module when you want to publish desktops or remote apps through AVD and bind them to a host pool.

resource "azurerm_virtual_desktop_application_group" "applicationGroup" {
  for_each = var.applicationGroupVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  host_pool_id        = var.hostpool_ids[each.value.hostpool_key]
  type                = each.value.type
 
  friendly_name                = try(each.value.friendly_name, null)
  description                  = try(each.value.description, null)
  default_desktop_display_name = try(each.value.default_desktop_display_name, null)
  tags = try(each.value.tags, {})
    lifecycle {
    prevent_destroy = true
  }
}
