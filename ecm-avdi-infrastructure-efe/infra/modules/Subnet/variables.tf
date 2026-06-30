variable "snetVariables" {
  description = "Map of subnets to create"
  type = map(object({
    vnetname       = string
    vnetrg        = string
    snetName      = string
    snetAddressPrefix = list(string)
  }))
}
