# This module creates Private Endpoints in Azure which can be used to securely connect to Azure services over a private link.
resource "azurerm_private_endpoint" "pvtEndpoint" {
  for_each = var.privateEndpointVariables
 
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = each.value.subnet_id
  tags =  try(each.value.tags, {})
  private_service_connection {
    name                           = "${each.value.name}-psc"
    private_connection_resource_id = each.value.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }
  lifecycle {
    prevent_destroy = true
  }
}
 
 
 
 
 