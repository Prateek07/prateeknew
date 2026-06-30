variable "dceAssociations" {
  description = "Map of DCE associations"
  type = map(object({
    name                        = string
    target_resource_id          = string
    data_collection_endpoint_id = string
    description                 = optional(string)
  }))
  default = {}
}