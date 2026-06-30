# role assignment for AVD application group
resource "azurerm_role_assignment" "avd_assignment" {
  for_each = var.application_group_assignments
 
  scope                = var.application_group_ids[each.value.application_group_key]
  role_definition_name = each.value.role_definition_name//"Desktop Virtualization User"
  principal_id         = each.value.principal_id 

}