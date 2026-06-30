# This module creates associations between Network Security Groups and Subnets in Azure which can be used to apply security rules to network traffic flowing through the associated subnets.
resource "azurerm_subnet_network_security_group_association" "nsgSubnetAssociation" {
  for_each = var.nsgSubnetAssociations
  subnet_id                 = each.value.snet_id
  network_security_group_id = each.value.nsg_id
  lifecycle {
    prevent_destroy = true
  }
}