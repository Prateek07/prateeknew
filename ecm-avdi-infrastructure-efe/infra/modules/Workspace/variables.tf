 
# variable "commonTags" {
#   description = "Tags applied to all resources (merged with per-object tags)."
#   type        = map(string)
#   default     = {}
# }
 
variable "workspaceVariables" {
  description = "Map of AVD Workspaces."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
 
    friendly_name = optional(string)
    description   = optional(string)
    tags          = optional(map(string), {})
    public_network_access_enabled = optional(bool)
  }))
}