# variable "commonTags" {
#   description = "Tags applied to all resources (merged with per-object tags)."
#   type        = map(string)
#   default     = {}
# }
 
variable "hostPoolVariables" {
  description = "Map of AVD Host Pools."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
 
    type               = string
    load_balancer_type = string
    friendly_name      = optional(string)
    description        = optional(string)
 
    preferred_app_group_type = optional(string)
    personal_desktop_assignment_type = optional(string)
    maximum_sessions_allowed = optional(number)
    start_vm_on_connect      = optional(bool)
 
    validate_environment  = optional(bool)
    custom_rdp_properties = optional(string)

    public_network_access = optional(string)
    # log_analytics_workspace_id = optional(string)
 
    tags = optional(map(string), {})
  }))
}
 