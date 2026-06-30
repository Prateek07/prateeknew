# Creates Azure Compute Galleries (ACGs) to store and manage custom VM images
# Use this module when session hosts or other VMs should consume centralized, versioned images.

resource "azurerm_shared_image_gallery" "acg" {
  for_each = var.acgVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  description         = try(each.value.description, null)
 
  tags =  try(each.value.tags, {})
    lifecycle {
    prevent_destroy = true
  }
}
