# variable "commonTags" {
#   description = "Tags applied to all resources (merged with per-object tags)."
#   type        = map(string)
#   default     = {}
# }
 
variable "hostpool_ids" {
  description = "Host pool IDs keyed by host pool key."
  type        = map(string)
}
 
variable "applicationGroupVariables" {
  description = "Map of AVD Application Groups."
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    hostpool_key                 = string
    type                         = string
    friendly_name                = optional(string)
    description                  = optional(string)
    default_desktop_display_name = optional(string)
    tags                         = optional(map(string), {})
  }))
}
 
 



