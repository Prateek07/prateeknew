#  This module creates Subnets in Azure which can be used to segment and organize network resources within a Virtual Network.  
resource "azurerm_subnet" "snet" {
  for_each = var.snetVariables
 
  name                 = each.value.snetName
  resource_group_name  = each.value.vnetrg
  virtual_network_name = each.value.vnetname
  address_prefixes     = each.value.snetAddressPrefix
   lifecycle {
    prevent_destroy = true
  }
}
 



