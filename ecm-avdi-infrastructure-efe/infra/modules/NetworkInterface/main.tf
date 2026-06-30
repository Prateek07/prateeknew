# This module creates Network Interfaces in Azure which can be attached to Virtual Machines or other resources that require network connectivity.
resource "azurerm_network_interface" "nic" {
  for_each = var.nicVariables
 
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
 
  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = try(each.value.private_ip_address_allocation, "Dynamic")
  }
 
  tags = try(each.value.tags, {})
 
  lifecycle {
    ignore_changes = [ip_configuration]
  }
}
 
 