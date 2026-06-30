# This module creates Resource Groups in Azure which can be used to organize and manage Azure resources.
resource "azurerm_resource_group" "rg" {
  for_each = var.rgVariables

  name = each.value.rgName
  location = each.value.rgLocation
  tags =  each.value.rgTags
  lifecycle {
    # prevent_destroy = true
  }
}
