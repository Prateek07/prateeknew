variable "serviceBusQueueVariables" {
  description = "Map of Service Bus queues. namespace_id is resolved by the env from ServiceBusNamespace or can be supplied directly. Optional queue attributes are exposed."
  type = map(object({
    name                                    = string
    namespace_id                            = string
    namespace_key                           = optional(string)
    lock_duration                           = optional(string, "PT1M")
    max_message_size_in_kilobytes           = optional(number)
    max_size_in_megabytes                   = optional(number)
    requires_duplicate_detection            = optional(bool, false)
    requires_session                        = optional(bool, false)
    default_message_ttl                     = optional(string, "P14D")
    dead_lettering_on_message_expiration    = optional(bool, true)
    duplicate_detection_history_time_window = optional(string)
    max_delivery_count                      = optional(number, 5)
    status                                  = optional(string, "Active")
    batched_operations_enabled              = optional(bool, true)
    auto_delete_on_idle                     = optional(string)
    partitioning_enabled                    = optional(bool, false)
    express_enabled                         = optional(bool, false)
    forward_to                              = optional(string)
    forward_dead_lettered_messages_to       = optional(string)
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))

  default = {}
}