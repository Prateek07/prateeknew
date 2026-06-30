variable "privateEndpointVariables" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_id           = string
    private_connection_resource_id = string
    subresource_names   = list(string)
    private_dns_zone_ids = optional(list(string))
    tags                = optional(map(string), {})
  }))
  default = {}
}
 
 
