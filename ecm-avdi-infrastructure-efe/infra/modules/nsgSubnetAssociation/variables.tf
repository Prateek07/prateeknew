variable "nsgSubnetAssociations" {
  description = "Map of associations keyed by logical name which NSG attaches to which subnet."
  type = map(object({
    nsg_id    = string
    snet_id   = string
  }))
  default = {}
  
}