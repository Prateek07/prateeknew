# Creates Azure Monitor Data Collection Rules (DCRs).
# Use of this module when you need to define what telemetry should be collected from VMs, such as performance counters and Windows event logs, and where that data should be sent.

resource "azurerm_monitor_data_collection_rule" "dcr" {
  for_each = var.dcrVariables
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  kind                = try(each.value.kind, "Windows")
  description         = try(each.value.description, null)
  data_collection_endpoint_id = try(each.value.data_collection_endpoint_id, null)
 
  destinations {
    log_analytics {
      name                  = each.value.destination_name
      workspace_resource_id = each.value.log_analytics_workspace_id
    }
  }

  dynamic "data_flow" {
    for_each = each.value.data_flows
    content {
      streams      = data_flow.value.streams
      destinations = data_flow.value.destinations
    }
  }

  data_sources {
    dynamic "performance_counter" {
      for_each = try(each.value.performance_counters, [])
      content {
        name                          = performance_counter.value.name
        streams                       = performance_counter.value.streams
        sampling_frequency_in_seconds = performance_counter.value.sampling_frequency_in_seconds
        counter_specifiers            = performance_counter.value.counter_specifiers
      }
    }

    dynamic "windows_event_log" {
      for_each = try(each.value.windows_event_logs, [])
      content {
        name           = windows_event_log.value.name
        streams        = windows_event_log.value.streams
        x_path_queries = windows_event_log.value.x_path_queries
      }
    }
  }
  tags =  try(each.value.tags, {})
}
