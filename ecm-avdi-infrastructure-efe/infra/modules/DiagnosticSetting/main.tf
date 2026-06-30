# This module creates Diagnostic Settings in Azure Monitor which can be used to collect and analyze logs and metrics from various Azure resources.
# The module allows for dynamic configuration of diagnostic setting properties such as log categories, metric categories, and log analytics workspace destinations through the use of variables.
data "azurerm_monitor_diagnostic_categories" "Diagnostic" {
  for_each    = var.diagnostic_settings
  resource_id = each.value.target_resource_id
}
 
resource "azurerm_monitor_diagnostic_setting" "DiagnosticSetting" {
  for_each = var.diagnostic_settings
 
  name                           = each.value.name
  target_resource_id             = each.value.target_resource_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
 
  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.Diagnostic[each.key].log_category_types)
    content {
      category = enabled_log.value
    }
  }
 
  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.Diagnostic[each.key].metrics)
    content {
      category = enabled_metric.value
    }
  }
  lifecycle {
    ignore_changes = [ log_analytics_destination_type , enabled_log , enabled_metric ]
  }
  
}
