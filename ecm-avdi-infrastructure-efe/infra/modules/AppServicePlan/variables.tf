variable "appServicePlanVariables" {
  description = "Map of App Service Plans. Use os_type = Windows for Windows Function Apps."
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    os_type                      = optional(string, "Windows")
    sku_name                     = optional(string, "Y1")
    worker_count                 = optional(number)
    per_site_scaling_enabled     = optional(bool)
    zone_balancing_enabled       = optional(bool)
    maximum_elastic_worker_count = optional(number)
    tags                         = optional(map(string), {})
  }))
  default = {}
}
 
