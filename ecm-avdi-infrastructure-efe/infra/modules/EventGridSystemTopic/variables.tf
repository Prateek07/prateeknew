variable "eventGridSystemTopicVariables" {
  description = "Map of Event Grid system topics. Optional attributes are exposed in the same style as SessionHost."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = optional(string, "Global")
    source_resource_id  = optional(string)
    topic_type          = optional(string, "Microsoft.Resources.ResourceGroups")
 
    identity_type = optional(string)
    identity_ids  = optional(list(string), [])
 
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
 
 
 