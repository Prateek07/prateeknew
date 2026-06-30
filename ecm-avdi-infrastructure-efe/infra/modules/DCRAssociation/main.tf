# Associates Azure Monitor Data Collection Rules (DCRs) to target resources such as session host virtual machines.

# Use of this module when a DCR must be attached to one or more VMs so data collection actually becomes active.

resource "azurerm_monitor_data_collection_rule_association" "dcr_association" {
  for_each = var.dcrAssociations
  name                    = each.value.name
  target_resource_id      = each.value.target_resource_id
  data_collection_rule_id = each.value.data_collection_rule_id
  description             = try(each.value.description, null)
}



 