# variable "commonTags" {
#   description = "Common tags to be applied to all resources"
#   type        = map(string)
#   default     = {}
# }
 
variable "dcrVariables" {
  description = "Map of DCR definitions"
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    kind                       = optional(string, "Windows")
    description                = optional(string)
    destination_name           = string
    log_analytics_workspace_id = string
    tags                       = optional(map(string), {})
    data_collection_endpoint_id = optional(string)
    data_flows = list(object({
      streams      = list(string)
      destinations = list(string)
    }))
    performance_counters = optional(list(object({
      name                          = string
      streams                       = list(string)
      sampling_frequency_in_seconds = number
      counter_specifiers            = list(string)
    })), [])
    windows_event_logs = optional(list(object({
      name           = string
      streams        = list(string)
      x_path_queries = list(string)
    })), [])
  }))
  default = {}
}

 