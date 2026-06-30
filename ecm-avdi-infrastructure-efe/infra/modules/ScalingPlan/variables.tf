# variable "commonTags" {
#   description = "Tags applied to all resources."
#   type        = map(string)
#   default     = {}
# }
 
variable "hostpool_ids" {
  description = "Host pool resource IDs by logical key."
  type        = map(string)
}
 
variable "resource_group_ids" {
  description = "Resource Group IDs by logical key."
  type        = map(string)
}
 
variable "scalingPlanVariables" {
  description = "Map of AVD personal scaling plans."
  type = map(object({
    name               = string
    resource_group_key = string
    location           = string
    time_zone          = string
    hostpool_key       = string
    hostPoolType       = string
    friendly_name = optional(string)
    description   = optional(string)
    exclusion_tag = optional(string)
    enabled       = optional(bool, true)
    tags          = optional(map(string), {})
 
    personal_schedules = list(object({
      name         = string
      days_of_week = list(string)
 
      ramp_up_start_time                    = string
      ramp_up_auto_start_hosts              = string
      ramp_up_start_vm_on_connect           = string
      ramp_up_action_on_disconnect          = string
      ramp_up_minutes_to_wait_on_disconnect = number
      ramp_up_action_on_logoff              = string
      ramp_up_minutes_to_wait_on_logoff     = number
 
      peak_start_time                    = string
      peak_start_vm_on_connect           = string
      peak_action_on_disconnect          = string
      peak_minutes_to_wait_on_disconnect = number
      peak_action_on_logoff              = string
      peak_minutes_to_wait_on_logoff     = number
 
      ramp_down_start_time                    = string
      ramp_down_start_vm_on_connect           = string
      ramp_down_action_on_disconnect          = string
      ramp_down_minutes_to_wait_on_disconnect = number
      ramp_down_action_on_logoff              = string
      ramp_down_minutes_to_wait_on_logoff     = number
 
      off_peak_start_time                    = string
      off_peak_start_vm_on_connect           = string
      off_peak_action_on_disconnect          = string
      off_peak_minutes_to_wait_on_disconnect = number
      off_peak_action_on_logoff              = string
      off_peak_minutes_to_wait_on_logoff     = number
    }))
  }))
  default = {}
 
}