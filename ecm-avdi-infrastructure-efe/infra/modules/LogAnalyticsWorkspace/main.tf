# This module creates Log Analytics Workspaces in Azure which can be used to collect and analyze logs and metrics from various Azure resources.
resource "azurerm_log_analytics_workspace" "LogAnalyticsWorkspace" {
  for_each = var.logAnalyticsWorkspaceVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
 
  sku                                = try(each.value.sku, null)
  retention_in_days                  = try(each.value.retention_in_days, null)
  daily_quota_gb                     = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled         = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled             = try(each.value.internet_query_enabled, null)
  reservation_capacity_in_gb_per_day = try(each.value.reservation_capacity_in_gb_per_day, null)
  local_authentication_enabled      = try(each.value.local_authentication_enabled, null)
 
  tags =  try(each.value.tags, {})
    lifecycle {
    prevent_destroy = true
  }
}