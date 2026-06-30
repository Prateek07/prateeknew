# This module creates Shared Image Gallery Image Definitions in Azure which can be used to manage and distribute custom VM images across regions. 
# The module allows for dynamic configuration of image definition properties such as OS type, hypervisor generation, and trusted launch support through the use of variables.
resource "azurerm_shared_image" "image_def" {
  for_each = var.imageDefinitionVariables
  name                = each.value.name
  gallery_name        = each.value.gallery_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  os_type             = each.value.os_type
  hyper_v_generation =  each.value.hyper_v_generation
  trusted_launch_enabled = try(each.value.trusted_launch_enabled, false)
  trusted_launch_supported =try(each.value.trusted_launch_supported, false)
  accelerated_network_support_enabled = each.value.accelerated_network_support_enabled
  identifier {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
  }
  description = try(each.value.description, null)
  tags        =  try(each.value.tags, {})
    lifecycle {
    # prevent_destroy = true
  }
}