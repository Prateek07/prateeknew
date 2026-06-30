variable "diagnostic_settings" {
  description = "Map of diagnostic settings to create."
  type = map(object({
    name                           = string
    target_resource_id             = string
    log_analytics_workspace_id     = string
    log_analytics_destination_type = optional(string, "Dedicated")
  }))
}