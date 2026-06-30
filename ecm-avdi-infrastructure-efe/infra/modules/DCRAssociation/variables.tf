variable "dcrAssociations" {
  description = "Map of DCR associations"
  type = map(object({
    name                    = string
    target_resource_id      = string
    data_collection_rule_id = string
    description             = optional(string)
  }))
  default = {}

}