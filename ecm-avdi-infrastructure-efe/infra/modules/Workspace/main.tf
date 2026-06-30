# This module creates Workspaces in Azure Virtual Desktop which can be used to organize and manage host pools, application groups, and user assignments within the Azure Virtual Desktop environment. 
resource "azurerm_virtual_desktop_workspace" "Workspace" {
  for_each = var.workspaceVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
 
  friendly_name = try(each.value.friendly_name, null)
  description   = try(each.value.description, null)
 
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  tags =  try(each.value.tags, {})
    lifecycle {
    prevent_destroy = true
  }
}
 
 