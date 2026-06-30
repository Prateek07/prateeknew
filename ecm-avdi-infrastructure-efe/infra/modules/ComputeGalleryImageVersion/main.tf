# Looks up existing Azure Compute Gallery image versions using Terraform data sources.
# Use this module when image versions are managed outside this repository, but their IDs are needed for VM deployment.

data "azurerm_shared_image_version" "image_version" {
  for_each = var.imageVersionDataVariables
 
  name                = each.value.version
  image_name          = each.value.image_name
  gallery_name        = each.value.gallery_name
  resource_group_name = each.value.resource_group_name
  
}