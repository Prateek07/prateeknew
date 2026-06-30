variable "imageVersionDataVariables" {
  description = "Map of Azure Compute Gallery image versions to look up."
  type = map(object({
    gallery_name        = string
    resource_group_name = string
    image_name          = string
    version             = string
  }))
  default = {}
}