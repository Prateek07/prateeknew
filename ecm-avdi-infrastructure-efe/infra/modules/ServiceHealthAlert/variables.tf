variable "default_scope" {
  description = "Default Service Health alert scope. For AVD Service Health, use subscription scope: /subscriptions/<subscription_id>."
  type        = string
}
 
variable "action_group_ids_map" {
  description = "Map of existing Action Group IDs by key, passed from module.ActionGroup."
  type        = map(string)
  default     = {}
}
 
variable "serviceHealthAlertVariables" {
  description = "Map of Azure Service Health activity log alert definitions"
 
  type = map(object({
    name                = string
    resource_group_name = string
    location            = optional(string, "global")
 
    # Optional override. If not provided, the module uses var.default_scope.
    scopes = optional(list(string))
 
    description       = optional(string)
    enabled           = optional(bool, true)
    action_group_keys = optional(list(string), [])
    tags              = optional(map(string), {})
 
    service_health = object({
      events    = optional(list(string), ["Incident"])
      locations = optional(list(string))
      services  = optional(list(string), ["Windows Virtual Desktop"])
    })
  }))
 
  default = {}
}