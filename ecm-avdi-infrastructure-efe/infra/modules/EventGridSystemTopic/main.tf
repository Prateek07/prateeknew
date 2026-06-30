resource "azurerm_eventgrid_system_topic" "eventGridSystemTopic" {
  for_each = var.eventGridSystemTopicVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, "Global")
  source_resource_id  = try(each.value.source_resource_id, null)
  topic_type          = try(each.value.topic_type, "Microsoft.Resources.ResourceGroups")
 
  dynamic "identity" {
    for_each = try(each.value.identity_type, null) != null || length(try(each.value.identity_ids, [])) > 0 ? [1] : []
    content {
      type         = coalesce(try(each.value.identity_type, null), length(try(each.value.identity_ids, [])) > 0 ? "UserAssigned" : "SystemAssigned")
      identity_ids = length(try(each.value.identity_ids, [])) > 0 ? each.value.identity_ids : null
    }
  }
 
  dynamic "timeouts" {
    for_each = try(each.value.timeouts, null) == null ? [] : [each.value.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
 
  tags = try(each.value.tags, {})
 
  lifecycle {
    prevent_destroy = true
  }
}
