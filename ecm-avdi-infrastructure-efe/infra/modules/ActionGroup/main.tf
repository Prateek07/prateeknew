# This module creates Action Groups in Azure Monitor which can be used for alert notifications and automation runbooks. 
# The module supports email, SMS, and webhook receivers, and allows for dynamic configuration of receiver properties through the use of variables. Action Groups can be associated with alerts in the Alerts module by referencing the Action Group IDs or keys defined in this module.
resource "azurerm_monitor_action_group" "action_groups" {
  for_each = var.actionGroupVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  short_name          = each.value.short_name
  enabled             = try(each.value.enabled, true)
  # tags                = merge(var.commonTags, try(each.value.tags, {}))
 
  dynamic "email_receiver" {
    for_each = try(each.value.email_receivers, [])
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = try(email_receiver.value.use_common_alert_schema, true)
    }
  }
  dynamic "sms_receiver" {
    for_each = try(each.value.sms_receivers, [])
    content {
      name                    = sms_receiver.value.name
      country_code            = sms_receiver.value.country_code
      phone_number            = sms_receiver.value.phone_number
    }
  }
  dynamic "webhook_receiver" {
    for_each = try(each.value.webhook_receivers, [])
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = try(webhook_receiver.value.use_common_alert_schema, true)
    }
  }
}