variable "acgVariables" {
  description = "Map of Azure Compute Galleries to create."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    description         = optional(string)
    tags                = optional(map(string), {})
  }))
  default = {}
}
# variable "commonTags" {
#   description = "Common tags applied to all resources."
#   type        = map(string)
#   default     = {}
# }
