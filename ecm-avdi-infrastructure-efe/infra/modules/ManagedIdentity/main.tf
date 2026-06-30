# This module creates User Assigned Managed Identities in Azure which can be used to provide applications and services with secure access to Azure resources without the need for credentials.
resource "azurerm_user_assigned_identity" "mIdentity" {
  for_each = var.mIdentity
  name = each.value.miName
  resource_group_name = each.value.miResourceGroup
  location = each.value.miLocation
  tags        = try(each.value.tags, {})
  lifecycle {
    prevent_destroy = true
  }
}