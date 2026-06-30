variable "applicationInsightsVariables" {
  description = "Map of Application Insights components used for Function App logging and monitoring."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
 
    application_type = optional(string, "web")
 
    # Use workspace_id directly or provide log_analytics_workspace_key at env level and resolve it in locals.tf.
    workspace_id                 = optional(string)
    log_analytics_workspace_key  = optional(string)
 
    daily_data_cap_in_gb                  = optional(number)
    daily_data_cap_notifications_disabled = optional(bool)
    retention_in_days                     = optional(number)
    sampling_percentage                   = optional(number)
    disable_ip_masking                    = optional(bool)
    local_authentication_disabled         = optional(bool)
    internet_ingestion_enabled            = optional(bool)
    internet_query_enabled                = optional(bool)
    force_customer_storage_for_profiler   = optional(bool)
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}