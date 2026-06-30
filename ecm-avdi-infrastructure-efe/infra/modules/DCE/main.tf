# Creates Azure Monitor Data Collection Endpoints (DCEs).
# Use this module when a DCR needs to be bound to a specific endpoint for data ingestion/configuration.
 
resource "azurerm_monitor_data_collection_endpoint" "dce" {
  for_each = var.dceVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  kind                = try(each.value.kind, "Windows")
  description         = try(each.value.description, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)
 
  tags = try(each.value.tags, {})
    lifecycle {
    prevent_destroy = true
  }
}
 