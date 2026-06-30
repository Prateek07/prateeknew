output "service_health_alerts" {
  description = "Azure Monitor Activity Log Service Health alerts"
  value       = azurerm_monitor_activity_log_alert.service_health_alerts
}