resource "azurerm_monitor_activity_log_alert" "service_health_alerts" {
  for_each = var.serviceHealthAlertVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, "global")
 
  # If scopes are provided in tfvars, use them.
  # Otherwise use the current subscription scope passed from the env main.tf.
  scopes = length(coalesce(try(each.value.scopes, null), [])) > 0 ? each.value.scopes : [var.default_scope]
 
  description = try(each.value.description, null)
  enabled     = try(each.value.enabled, true)
  tags        = try(each.value.tags, {})
 
  criteria {
    category = "ServiceHealth"
 
    service_health {
      events    = try(each.value.service_health.events, ["Incident"])
      locations = try(each.value.service_health.locations, null)
      services  = try(each.value.service_health.services, ["Windows Virtual Desktop"])
    }
  }
 
  dynamic "action" {
    for_each = toset(try(each.value.action_group_keys, []))
 
    content {
      action_group_id = var.action_group_ids_map[action.value]
    }
  }
}