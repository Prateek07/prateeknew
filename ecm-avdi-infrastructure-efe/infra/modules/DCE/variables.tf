# variable "commonTags" {
#   description = "Common tags to be applied to all resources"
#   type        = map(string)
#   default     = {}
# }
 
variable "dceVariables" {
  description = "Map of DCE definitions"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    kind                          = optional(string, "Windows")
    description                   = optional(string)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string), {})
  }))
  default = {}
}