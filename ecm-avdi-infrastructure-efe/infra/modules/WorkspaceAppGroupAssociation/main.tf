# This module creates associations between Workspaces and Application Groups in Azure Virtual Desktop, allowing users to access applications published in the associated Application Groups through the Workspaces. The associations are defined based on the input variables provided to the module.
resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceApplicationGroupAssociation" {
  for_each = var.workspaceAssociationVariables
 
  workspace_id         = var.workspace_ids[each.value.workspace_key]
  application_group_id = var.application_group_ids[each.value.application_group_key]
  lifecycle {
    prevent_destroy = true
  }
}


