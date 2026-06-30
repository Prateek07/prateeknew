resource "azurerm_application_insights" "applicationInsights" {
  for_each = var.applicationInsightsVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  application_type    = try(each.value.application_type, "web")
 
  workspace_id                           = try(each.value.workspace_id, null)
  daily_data_cap_in_gb                   = try(each.value.daily_data_cap_in_gb, null)
  daily_data_cap_notifications_disabled  = try(each.value.daily_data_cap_notifications_disabled, null)
  retention_in_days                      = try(each.value.retention_in_days, null)
  sampling_percentage                    = try(each.value.sampling_percentage, null)
  disable_ip_masking                     = try(each.value.disable_ip_masking, null)
  local_authentication_disabled          = try(each.value.local_authentication_disabled, null)
  internet_ingestion_enabled             = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled                 = try(each.value.internet_query_enabled, null)
  force_customer_storage_for_profiler    = try(each.value.force_customer_storage_for_profiler, null)
 
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
 