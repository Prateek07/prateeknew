# variable "commonTags" {
#   description = "Common tags to be applied to all resources"
#   type        = map(string)
#   default     = {}
# }
 
variable "actionGroupVariables" {
  description = "Map of action groups"
  type = map(object({
    name                = string
    resource_group_name = string
    short_name          = string
    enabled             = optional(bool, true)
    # tags                = optional(map(string), {})
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    sms_receivers = optional(list(object({
      name                    = string
      country_code            = string
      phone_number            = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    webhook_receivers = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = optional(bool, true)
    })), [])
  }))
  default = {}
}