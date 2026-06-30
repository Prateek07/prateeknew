# variable "commonTags" {
#   description = "Common tags to be applied to all resources"
#   type        = map(string)
#   default     = {}
# }
 
variable "workspace_ids" {
  description = "Map of Log Analytics Workspace IDs by key"
  type        = map(string)
}
variable "action_group_ids_map" {
  description = "Optional map of Action Group IDs by key"
  type        = map(string)
  default     = {}
}
variable "alertVariables" {
  description = "Map of scheduled query alert definitions"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
     log_analytics_workspace_key  = string
    description          = optional(string)
    severity             = number
    enabled              = optional(bool, true)
    evaluation_frequency = string
    window_duration      = string
    action_group_keys    = optional(list(string), [])
    # tags                 = optional(map(string), {})
 
    criteria = object({
      query                   = string
      time_aggregation_method = string
      threshold               = number
      operator                = string
      metric_measure_column   = string
      resource_id_column      = optional(string)
 
      failing_periods = object({
        minimum_failing_periods_to_trigger_alert = number
        number_of_evaluation_periods             = number
      })
    })
  }))
  default = {}
}