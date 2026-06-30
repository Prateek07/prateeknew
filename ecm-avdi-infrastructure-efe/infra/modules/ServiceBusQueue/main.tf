resource "azurerm_servicebus_queue" "serviceBusQueue" {
  for_each = var.serviceBusQueueVariables
 
  name         = each.value.name
  namespace_id = each.value.namespace_id
 
  lock_duration                           = try(each.value.lock_duration, "PT1M")
  max_message_size_in_kilobytes           = try(each.value.max_message_size_in_kilobytes, null)
  max_size_in_megabytes                   = try(each.value.max_size_in_megabytes, null)
  requires_duplicate_detection            = try(each.value.requires_duplicate_detection, false)
  requires_session                        = try(each.value.requires_session, false)
  default_message_ttl                     = try(each.value.default_message_ttl, "P14D")
  dead_lettering_on_message_expiration    = try(each.value.dead_lettering_on_message_expiration, true)
  duplicate_detection_history_time_window = try(each.value.duplicate_detection_history_time_window, null)
  max_delivery_count                      = try(each.value.max_delivery_count, 5)
  status                                  = try(each.value.status, "Active")
  batched_operations_enabled              = try(each.value.batched_operations_enabled, true)
  auto_delete_on_idle                     = try(each.value.auto_delete_on_idle, null)
  partitioning_enabled                    = try(each.value.partitioning_enabled, false)
  express_enabled                         = try(each.value.express_enabled, false)
  forward_to                              = try(each.value.forward_to, null)
  forward_dead_lettered_messages_to       = try(each.value.forward_dead_lettered_messages_to, null)
 
  dynamic "timeouts" {
    for_each = try(each.value.timeouts, null) == null ? [] : [each.value.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
 
  lifecycle {
    prevent_destroy = true
  }
}
 