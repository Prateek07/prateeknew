
# Associates Azure Monitor Data Collection Endpoints (DCEs) to target resources such as session host virtual machines.
resource "azurerm_monitor_data_collection_rule_association" "dce_association" {
  for_each = var.dceAssociations
  name                        = each.value.name
  target_resource_id          = each.value.target_resource_id
  data_collection_endpoint_id = each.value.data_collection_endpoint_id
  description                 = try(each.value.description, null)
}