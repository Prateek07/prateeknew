# This module creates Scheduled Query Rules (Alerts) in Azure Monitor which can be used to monitor log data in Log Analytics workspaces and trigger notifications or automation runbooks based on defined criteria. 
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alerts" {
  for_each = var.alertVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  description         = try(each.value.description, null)
 
  scopes = [
    var.workspace_ids[each.value.log_analytics_workspace_key]
  ]
 
  severity             = each.value.severity
  enabled              = try(each.value.enabled, true)
  evaluation_frequency = each.value.evaluation_frequency
  window_duration      = each.value.window_duration
 
  criteria {
    query                   = each.value.criteria.query
    time_aggregation_method = each.value.criteria.time_aggregation_method
    threshold               = each.value.criteria.threshold
    operator                = each.value.criteria.operator
    metric_measure_column   = each.value.criteria.metric_measure_column
    resource_id_column      = try(each.value.criteria.resource_id_column, null)
 
    failing_periods {
      minimum_failing_periods_to_trigger_alert = each.value.criteria.failing_periods.minimum_failing_periods_to_trigger_alert
      number_of_evaluation_periods             = each.value.criteria.failing_periods.number_of_evaluation_periods
    }
  }
  dynamic "action" {
      for_each = length([
        for ag_key in try(each.value.action_group_keys, []) :
        var.action_group_ids_map[ag_key]
        if contains(keys(var.action_group_ids_map), ag_key)
      ]) > 0 ? [1] : []
      content {
        action_groups = [
          for ag_key in try(each.value.action_group_keys, []) :
          var.action_group_ids_map[ag_key]
          if contains(keys(var.action_group_ids_map), ag_key)
        ]
      }
    }
 
  # tags = merge(var.commonTags, try(each.value.tags, {}))
}