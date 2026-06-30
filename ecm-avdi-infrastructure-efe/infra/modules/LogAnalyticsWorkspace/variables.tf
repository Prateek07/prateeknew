# variable "commonTags" {
#   description = "Tags applied to all resources (merged with per-object tags)."
#   type        = map(string)
#   default     = {}
# }
 
variable "logAnalyticsWorkspaceVariables" {
  description = "Map of Log Analytics Workspaces."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
 
    sku                               = optional(string)
    retention_in_days                 = optional(number)
    daily_quota_gb                    = optional(number)
    internet_ingestion_enabled        = optional(bool)
    internet_query_enabled            = optional(bool)
    reservation_capacity_in_gb_per_day = optional(number)
    local_authentication_enabled     = optional(bool)
    tags                              = optional(map(string), {})
  }))
  default = {}
}