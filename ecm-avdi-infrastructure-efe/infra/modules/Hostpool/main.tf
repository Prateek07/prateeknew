# This module creates Host Pools in Azure Virtual Desktop which are used to manage and scale session hosts for remote desktop and application virtualization. The module allows for dynamic configuration of host pool properties such as load balancing, session limits, and custom RDP settings through the use of variables. 
# Host Pools can be associated with session hosts created in the SessionHost module by referencing the Host Pool IDs defined in this module.
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  for_each = var.hostPoolVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
 
  type               = each.value.type
  load_balancer_type = each.value.load_balancer_type
 
  friendly_name = try(each.value.friendly_name, null)
  description   = try(each.value.description, null)
  personal_desktop_assignment_type = try(each.value.personal_desktop_assignment_type, null)
  preferred_app_group_type = try(each.value.preferred_app_group_type, null)
  maximum_sessions_allowed = try(each.value.maximum_sessions_allowed, null)
  start_vm_on_connect      = try(each.value.start_vm_on_connect, null)
 
  validate_environment  = try(each.value.validate_environment, null)
  custom_rdp_properties = try(each.value.custom_rdp_properties, null)
 
  public_network_access = try(each.value.public_network_access, null)
  tags = try(each.value.tags, {})
 lifecycle {
   ignore_changes = [ custom_rdp_properties ]
     prevent_destroy = true
 }
}
