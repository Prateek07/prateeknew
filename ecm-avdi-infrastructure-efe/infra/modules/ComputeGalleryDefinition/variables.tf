variable "imageDefinitionVariables" {
    description = "Map of Azure Compute Gallery Image Definitions to create."
    type = map(object({
        name                = string
        gallery_name        = string
        resource_group_name = string
        location            = string
        os_type             = string
        trusted_launch_enabled = optional(bool)
        trusted_launch_supported = optional(bool)
        hyper_v_generation  = string
        publisher           = string
        offer               = string
        sku                 = string
        description         = optional(string)
        tags                = optional(map(string), {})
        accelerated_network_support_enabled = optional(bool, true)
    }))
}
# variable "commonTags" {
#   description = "Common tags applied to all resources."
#   type        = map(string)
#   default     = {}
# }