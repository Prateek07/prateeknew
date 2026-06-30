variable "rgVariables" {
  description = "Resource group definition keyed by logical name."
  type = map(object({
    rgName          = string
    rgLocation      = string
    rgTags  = map(string)
  }))
}

variable "snetVariables" {
  description = "Map of subnets to create"
  type = map(object({
    vnetrg        = string
    vnetname      = string
    snetName      = string
    snetAddressPrefix = list(string)
  }))
}

# variable "commonTags" {
#   description = "Common tags applied to all resources."
#   type        = map(string)
#   default     = {}
# }

variable "nsgVariables" {
  description = "Map of NSGs to create."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string), {})
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string  
      access                     = string  
      protocol                   = string 
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      description                = optional(string)
    })), [])
  }))
}
variable "nsgSubnetAssociations" {
  description = "Map of associations keyed by logical name: which NSG attaches to which subnet."
  type = map(object({
    nsg_key    = string
    subnet_key = string
  }))
  default = {}

}
variable "workspaceVariables" {
  description = "Map of AVD Workspaces."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    friendly_name                 = optional(string)
    description                   = optional(string)
    tags                          = optional(map(string), {})
    public_network_access_enabled = optional(bool)
    log_analytics_workspace_key = optional(string)
  }))
}
variable "hostPoolVariables" {
  description = "Map of AVD Host Pools."
  type = map(object({
    name                             = string
    resource_group_name              = string
    location                         = string
    type                             = string
    load_balancer_type               = string
    friendly_name                    = optional(string)
    description                      = optional(string)
    personal_desktop_assignment_type = optional(string)
    preferred_app_group_type         = optional(string)
    maximum_sessions_allowed         = optional(number)
    start_vm_on_connect              = optional(bool)
    validate_environment             = optional(bool)
    custom_rdp_properties            = optional(string)
    public_network_access            = optional(string)
    log_analytics_workspace_key      = optional(string)
    tags                             = optional(map(string), {})
  }))
}


variable "privateEndpointVariables" {
  description = "Map of Private Endpoints to create."
  type = map(object({
    name                  = string
    resource_group_name   = string
    location              = string
    subnet_key            = string
    subresource_names     = list(string)
    target_type           = string  
    target_key            = string
    private_dns_zone_ids  = optional(list(string), [])
    tags                  = optional(map(string), {})
  }))
}

variable "applicationGroupVariables" {
  description = "Map of AVD Application Groups."
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    hostpool_key                 = string
    type                         = string
    friendly_name                = optional(string)
    description                  = optional(string)
    default_desktop_display_name = optional(string)
    tags                         = optional(map(string), {})
  }))
  default = {}
}
variable "workspaceAssociationVariables" {
  description = "Map of workspace to application group associations."
  type = map(object({
    workspace_key         = string
    application_group_key = string
  }))
  default = {}
}

variable "logAnalyticsWorkspaceVariables" {
  description = "Map of Log Analytics Workspaces."
  type = map(object({
    name                                 = string
    resource_group_name                  = string
    location                             = string
    sku                                  = optional(string)
    retention_in_days                    = optional(number)
    daily_quota_gb                       = optional(number)
    internet_ingestion_enabled           = optional(bool)
    internet_query_enabled               = optional(bool)
    reservation_capacity_in_gb_per_day   = optional(number)
    local_authentication_enabled        = optional(bool)
    tags                                 = optional(map(string), {})
  }))
  default = {}
}
variable "keyVaultVariables" {
  description = "Map of Key Vaults."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku_name                      = string
    rbac_authorization_enabled     = optional(bool, true)
    purge_protection_enabled      = optional(bool, true)
    soft_delete_retention_days    = optional(number, 90)
    public_network_access_enabled = optional(bool, false)
    tags                          = optional(map(string), {})

  }))
  default = {}
}
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
variable "imageDefinitionVariables" {
  description = "Map of Azure Compute Gallery Image Definitions to create."
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    gallery_key              = string
    os_type                  = string
    trusted_launch_supported = optional(bool)
    trusted_launch_enabled   = optional(bool)
    publisher                = string
    offer                    = string
    sku                      = string
    hyper_v_generation       = string
    accelerated_network_support_enabled = optional(bool, true)
    description              = optional(string)
    tags                     = optional(map(string), {})
  }))
}
variable "imageVersionDataVariables" {
  description = "Map of Azure Compute Gallery image versions to look up."
  type = map(object({
    gallery_key = string
    rg_key      = string
    image_name  = string
    version     = string
  }))
  default = {}
}
variable "sessionHostVariables" {
  description = "Map of session host configurations. Each key represents one host group tied to a host pool."
  type = map(object({
    hostpool_key                 = string
    prefix                       = string
    start_index                  = number
    session_host_count           = number
    deleted_hosts                = optional(list(string), [])
    rg_key                       = string
    subnet_key                   = string
    vm_size                      = string
 
    admin_username               = string
    admin_password               = string
    domain_name                  = string
    domain_join_username         = string
    domain_join_password         = string
 
    key_vault_key                = optional(string)
    ou_path                      = optional(string)
    tags                         = optional(map(string), {})
 
    os_disk_storage_account_type = optional(string, "Premium_LRS")
    disk_size_gb              = optional(number)
 
    gallery_image_version_key    = optional(string)
 
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    }))
    enable_nvidia_gpu_driver = optional(bool, false)
    vtpm_enabled = optional(bool, true)
    secure_boot_enabled = optional(bool, true)
  }))
}
variable "dceVariables" {
  description = "Map of DCE definitions from tfvars"
  type = map(object({
    name                    = string
    resource_group_name     = string
    location                = string
    kind                    = optional(string, "Windows")
    description             = optional(string)
    association_description = optional(string)
    session_host_keys       = optional(list(string), [])
    tags                    = optional(map(string), {})
    public_network_access_enabled = optional(bool, true)
  }))
  default = {}
}
variable "dcrVariables" {
  description = "Map of DCR definitions from tfvars"
  type = map(object({
    name                        = string
    resource_group_name         = string
    location                    = string
    kind                        = optional(string, "Windows")
    description                 = optional(string)
    destination_name            = string
    log_analytics_workspace_key = string
    session_host_keys           = list(string)
    association_description     = optional(string)
    tags                        = optional(map(string), {})
     data_collection_endpoint_key = optional(string)
    data_flows = list(object({
      streams      = list(string)
      destinations = list(string)
    }))
    performance_counters = optional(list(object({
      name                          = string
      streams                       = list(string)
      sampling_frequency_in_seconds = number
      counter_specifiers            = list(string)
    })), [])
    windows_event_logs = optional(list(object({
      name           = string
      streams        = list(string)
      x_path_queries = list(string)
    })), [])
  }))
  default = {}
}
 
 
variable "scalingPlanVariables" {
  description = "Map of AVD personal scaling plans."
  type = map(object({
    name               = string
    resource_group_key = string
    location           = string
    time_zone          = string
    hostpool_key       = string
    hostPoolType       = string
    friendly_name = optional(string)
    description   = optional(string)
    exclusion_tag = optional(string)
    enabled       = optional(bool, true)
    tags          = optional(map(string), {})
    personal_schedules = list(object({
      name         = string
      days_of_week = list(string)
 
      ramp_up_start_time                    = string
      ramp_up_auto_start_hosts              = string
      ramp_up_start_vm_on_connect           = string
      ramp_up_action_on_disconnect          = string
      ramp_up_minutes_to_wait_on_disconnect = number
      ramp_up_action_on_logoff              = string
      ramp_up_minutes_to_wait_on_logoff     = number
 
      peak_start_time                    = string
      peak_start_vm_on_connect           = string
      peak_action_on_disconnect          = string
      peak_minutes_to_wait_on_disconnect = number
      peak_action_on_logoff              = string
      peak_minutes_to_wait_on_logoff     = number
 
      ramp_down_start_time                    = string
      ramp_down_start_vm_on_connect           = string
      ramp_down_action_on_disconnect          = string
      ramp_down_minutes_to_wait_on_disconnect = number
      ramp_down_action_on_logoff              = string
      ramp_down_minutes_to_wait_on_logoff     = number
 
      off_peak_start_time                    = string
      off_peak_start_vm_on_connect           = string
      off_peak_action_on_disconnect          = string
      off_peak_minutes_to_wait_on_disconnect = number
      off_peak_action_on_logoff              = string
      off_peak_minutes_to_wait_on_logoff     = number
    }))
  }))
  default = {}
}
variable "alertVariables" {
  description = "Map of scheduled query alert definitions"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    log_analytics_workspace_key   = string
    description          = optional(string)
    severity             = number
    enabled              = optional(bool, true)
    evaluation_frequency = string
    window_duration      = string
    action_group_keys   = optional(list(string), [])
    # tags                 = optional(map(string), {})
 
    criteria = object({
      query                   = string
      time_aggregation_method = string
      threshold               = number
      operator                = string
      metric_measure_column   = string
      resource_id_column      = optional(string)
 
      failing_periods = object({
        minimum_failing_periods_to_trigger_alert = number
        number_of_evaluation_periods             = number
      })
    })
  }))
  default = {}
}
variable "actionGroupVariables" {
  description = "Map of action group definitions."
  type = map(object({
    name                = string
    resource_group_name = string
    short_name          = string
    enabled             = optional(bool, true)
    email_receivers     = optional(list(object({
      name         = string
      email_address = string
      status       = optional(string, "Enabled")
    })), [])
    sms_receivers       = optional(list(object({
      name       = string
      country_code = string
      phone_number = string
      status     = optional(string, "Enabled")
    })), [])
    webhook_receivers   = optional(list(object({
      name        = string
      service_uri  = string
      status      = optional(string, "Enabled")
    })), [])
  }))
  
}
variable "application_group_assignments" {
  description = "Map of Azure AD groups to assign to AVD Application Groups."
  type = map(object({
    application_group_key = string
    principal_id    = string
    role_definition_name = string
  }))
  default = {}
}
variable "serviceHealthAlertVariables" {
  description = "Map of Azure Service Health activity log alert definitions"
 
  type = map(object({
    name                = string
    resource_group_name = string
    location            = optional(string, "global")
 
    # Optional override. If omitted, module.ServiceHealthAlert uses default_scope
    # from the env main.tf, which is the current subscription.
    scopes = optional(list(string))
 
    description       = optional(string)
    enabled           = optional(bool, true)
    action_group_keys = optional(list(string), [])
    tags              = optional(map(string), {})
 
    service_health = object({
      events    = optional(list(string), ["Incident"])
      locations = optional(list(string))
      services  = optional(list(string), ["Windows Virtual Desktop"])
    })
  }))
 
  default = {}
}

# VM lifecycle Automation
variable "mIdentity" {
  description = "Map of user-assigned managed identities used by the AVD Entra cleanup automation."
  type = map(object({
    miName          = string
    miResourceGroup = string
    miLocation      = string
    tags            = optional(map(string), {})
  }))
  default = {}
}
variable "serviceBusNamespaceVariables" {
  description = "Map of Service Bus namespaces for AVD VM delete cleanup events. Optional attributes are exposed in the same style as SessionHost."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    capacity                      = optional(number)
    premium_messaging_partitions  = optional(number)
    minimum_tls_version           = optional(string, "1.2")
    local_auth_enabled            = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
 
    identity_type = optional(string)
    identity_ids  = optional(list(string), [])
 
    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      identity_id                       = string
      infrastructure_encryption_enabled = optional(bool)
    }))
 
    network_rule_set = optional(object({
      default_action                = optional(string, "Allow")
      public_network_access_enabled = optional(bool, true)
      trusted_services_allowed      = optional(bool)
      ip_rules                      = optional(list(string), [])
      network_rules = optional(list(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      })), [])
    }))
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}
variable "serviceBusQueueVariables" {
  description = "Map of Service Bus queues for AVD VM delete cleanup events."
  type = map(object({
    name                                    = string
    namespace_key                           = optional(string)
    namespace_id                            = optional(string)
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

variable "storageAccountVariables" {
  description = "Map of Storage Accounts. Used for Windows Function App backing storage."
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    account_kind                    = optional(string, "StorageV2")
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    access_tier                     = optional(string, "Hot")
    min_tls_version                 = optional(string, "TLS1_2")
    https_traffic_only_enabled      = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    shared_access_key_enabled       = optional(bool, true)
    public_network_access_enabled   = optional(bool, true)
    tags                            = optional(map(string), {})
  }))
  default = {}
} 
variable "appServicePlanVariables" {
  description = "Map of App Service Plans for Windows Function Apps."
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
variable "applicationInsightsVariables" {
  description = "Map of Application Insights components used for Function App logging and monitoring."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
 
    application_type = optional(string, "web")
 
    workspace_id                = optional(string)
    log_analytics_workspace_key = optional(string)
 
    daily_data_cap_in_gb                  = optional(number)
    daily_data_cap_notifications_disabled = optional(bool)
    retention_in_days                     = optional(number)
    sampling_percentage                   = optional(number)
    disable_ip_masking                    = optional(bool)
    local_authentication_disabled         = optional(bool)
    internet_ingestion_enabled            = optional(bool)
    internet_query_enabled                = optional(bool)
    force_customer_storage_for_profiler   = optional(bool)
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}

/*
variable "eventGridSystemTopicVariables" {
  description = "Map of Event Grid system topics. source_resource_group_key points to the RG that contains the AVD VMs. source_resource_id can be supplied directly if needed."
  type = map(object({
    name                      = string
    resource_group_name       = string
    location                  = optional(string, "Global")
    source_resource_group_key = optional(string)
    source_resource_id        = optional(string)
    topic_type                = optional(string, "Microsoft.Resources.ResourceGroups")
    identity_key              = optional(string)
    identity_type             = optional(string)
    identity_ids              = optional(list(string), [])
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "eventGridSubscriptionVariables" {
  description = "Map of Event Grid subscriptions that send VM delete events to Service Bus. Optional endpoint, filtering, retry and dead-letter settings are exposed."
  type = map(object({
    name                = string
    resource_group_name = string
    system_topic_key    = optional(string)
    system_topic        = optional(string)
 
    expiration_time_utc   = optional(string)
    event_delivery_schema = optional(string, "EventGridSchema")
 
    azure_function_endpoint = optional(object({
      function_id                       = string
      max_events_per_batch              = optional(number)
      preferred_batch_size_in_kilobytes = optional(number)
    }))
 
    eventhub_endpoint_id          = optional(string)
    hybrid_connection_endpoint_id = optional(string)
    service_bus_queue_key         = optional(string)
    service_bus_queue_endpoint_id = optional(string)
    service_bus_topic_endpoint_id = optional(string)
 
    storage_queue_endpoint = optional(object({
      storage_account_id                    = string
      queue_name                            = string
      queue_message_time_to_live_in_seconds = optional(number)
    }))
 
    webhook_endpoint = optional(object({
      url                               = string
      max_events_per_batch              = optional(number)
      preferred_batch_size_in_kilobytes = optional(number)
      active_directory_tenant_id        = optional(string)
      active_directory_app_id_or_uri    = optional(string)
    }))
 
    included_event_types = optional(list(string), ["Microsoft.Resources.ResourceDeleteSuccess"])
 
    subject_filter = optional(object({
      subject_begins_with = optional(string)
      subject_ends_with   = optional(string)
      case_sensitive      = optional(bool)
    }))
 
    operation_names = optional(list(string), ["Microsoft.Compute/virtualMachines/delete"])
    advanced_filtering_on_arrays_enabled = optional(bool, false)
 
    advanced_filter = optional(object({
      bool_equals = optional(list(object({ key = string, value = bool })), [])
      number_greater_than = optional(list(object({ key = string, value = number })), [])
      number_greater_than_or_equals = optional(list(object({ key = string, value = number })), [])
      number_less_than = optional(list(object({ key = string, value = number })), [])
      number_less_than_or_equals = optional(list(object({ key = string, value = number })), [])
      number_in = optional(list(object({ key = string, values = list(number) })), [])
      number_not_in = optional(list(object({ key = string, values = list(number) })), [])
      number_in_range = optional(list(object({ key = string, values = list(list(number)) })), [])
      number_not_in_range = optional(list(object({ key = string, values = list(list(number)) })), [])
      string_begins_with = optional(list(object({ key = string, values = list(string) })), [])
      string_not_begins_with = optional(list(object({ key = string, values = list(string) })), [])
      string_ends_with = optional(list(object({ key = string, values = list(string) })), [])
      string_not_ends_with = optional(list(object({ key = string, values = list(string) })), [])
      string_contains = optional(list(object({ key = string, values = list(string) })), [])
      string_not_contains = optional(list(object({ key = string, values = list(string) })), [])
      string_in = optional(list(object({ key = string, values = list(string) })), [])
      string_not_in = optional(list(object({ key = string, values = list(string) })), [])
      is_not_null = optional(list(object({ key = string })), [])
      is_null_or_undefined = optional(list(object({ key = string })), [])
    }))
 
    delivery_identity_key  = optional(string)
    delivery_identity_type = optional(string)
    delivery_identity_id   = optional(string)
 
    delivery_properties = optional(list(object({
      header_name  = string
      type         = string
      value        = optional(string)
      source_field = optional(string)
      secret       = optional(bool)
    })), [])
 
    dead_letter_identity_type = optional(string)
    dead_letter_identity_id   = optional(string)
 
    storage_blob_dead_letter_destination = optional(object({
      storage_account_id          = string
      storage_blob_container_name = string
    }))
 
    max_delivery_attempts = optional(number, 10)
    event_time_to_live    = optional(number, 1440)
    labels                = optional(list(string), [])
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
  default = {}
}

variable "windowsFunctionAppVariables" {
  description = "Map of Windows Function Apps that process Service Bus messages and delete Entra devices. Optional root and site_config settings are exposed."
  type = map(object({
    name                      = string
    resource_group_name       = string
    location                  = string
    app_service_plan_key      = string
    service_plan_id           = optional(string)
    storage_account_key       = string
    storage_account_name      = optional(string)
    storage_account_access_key = optional(string)
    storage_uses_managed_identity = optional(bool)
    storage_key_vault_secret_id   = optional(string)
    managed_identity_key      = string
    identity_type             = optional(string)
    identity_ids              = optional(list(string), [])
    service_bus_namespace_key       = string
    service_bus_queue_key           = string
    application_insights_resource_key = optional(string)
 
    app_settings                    = optional(map(string), {})
    functions_worker_runtime        = optional(string, "powershell")
    set_runtime_app_settings        = optional(bool, false)
    functions_extension_version     = optional(string, "~4")
    powershell_core_version         = optional(string, "7.4")
    https_only                      = optional(bool, true)
    builtin_logging_enabled         = optional(bool, true)
    public_network_access_enabled   = optional(bool, true)
    key_vault_reference_identity_id = optional(string)
 
    client_certificate_enabled         = optional(bool)
    client_certificate_mode            = optional(string)
    client_certificate_exclusion_paths = optional(string)
    content_share_force_disabled       = optional(bool)
    daily_memory_time_quota            = optional(number)
    enabled                            = optional(bool)
    ftp_publish_basic_authentication_enabled      = optional(bool)
    virtual_network_backup_restore_enabled        = optional(bool)
    virtual_network_subnet_id                     = optional(string)
    vnet_image_pull_enabled                       = optional(bool)
    webdeploy_publish_basic_authentication_enabled = optional(bool)
    zip_deploy_file                               = optional(string)
 
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool)
      unauthenticated_client_action  = optional(string)
      active_directory = optional(object({
        client_id                  = string
        allowed_audiences          = optional(list(string))
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
      }))
    }))
 
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool)
      runtime_version                         = optional(string)
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string)
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool)
      http_route_api_prefix                   = optional(string)
      forward_proxy_convention                = optional(string)
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string))
        jwt_allowed_client_applications      = optional(list(string))
        www_authentication_disabled          = optional(bool)
        allowed_groups                       = optional(list(string))
        allowed_identities                   = optional(list(string))
        allowed_applications                 = optional(list(string))
        login_parameters                     = optional(map(string))
        allowed_audiences                    = optional(list(string))
      }))
      login = optional(object({
        logout_endpoint                   = optional(string)
        token_store_enabled               = optional(bool)
        token_refresh_extension_time      = optional(number)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
        preserve_url_fragments_for_logins = optional(bool)
        allowed_external_redirect_urls    = optional(list(string))
        cookie_expiration_convention      = optional(string)
        cookie_expiration_time            = optional(string)
        validate_nonce                    = optional(bool)
        nonce_expiration_time             = optional(string)
      }))
    }))
 
    backup = optional(object({
      name                = string
      storage_account_url = string
      enabled             = optional(bool)
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = optional(bool)
        retention_period_days    = optional(number)
        start_time               = optional(string)
      })
    }))
 
    connection_strings = optional(list(object({ name = string, type = string, value = string })), [])
 
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string))
      connection_string_names = optional(list(string))
    }))
 
    storage_accounts = optional(list(object({
      name         = string
      type         = string
      account_name = string
      share_name   = string
      access_key   = string
      mount_path   = optional(string)
    })), [])
 
    always_on                              = optional(bool, false)
    api_definition_url                     = optional(string)
    api_management_api_id                  = optional(string)
    app_command_line                       = optional(string)
    app_scale_limit                        = optional(number)
    application_insights_connection_string = optional(string)
    application_insights_key               = optional(string)
    default_documents                      = optional(list(string))
    elastic_instance_minimum               = optional(number)
    ftps_state                             = optional(string, "Disabled")
    health_check_path                      = optional(string)
    health_check_eviction_time_in_min      = optional(number)
    http2_enabled                          = optional(bool, true)
    ip_restriction_default_action          = optional(string)
    load_balancing_mode                    = optional(string)
    managed_pipeline_mode                  = optional(string)
    minimum_tls_version                    = optional(string, "1.2")
    pre_warmed_instance_count              = optional(number)
    remote_debugging_enabled               = optional(bool)
    remote_debugging_version               = optional(string)
    runtime_scale_monitoring_enabled       = optional(bool)
    scm_ip_restriction_default_action      = optional(string)
    scm_minimum_tls_version                = optional(string)
    minimum_tls_cipher_suite               = optional(string)
    scm_use_main_ip_restriction            = optional(bool)
    use_32_bit_worker                      = optional(bool)
    vnet_route_all_enabled                 = optional(bool)
    websockets_enabled                     = optional(bool)
    worker_count                           = optional(number)
 
    application_stack = optional(object({
      dotnet_version              = optional(string)
      use_dotnet_isolated_runtime = optional(bool)
      java_version                = optional(string)
      node_version                = optional(string)
      powershell_core_version     = optional(string)
      use_custom_runtime          = optional(bool)
    }))
 
    app_service_logs = optional(object({
      disk_quota_mb         = optional(number)
      retention_period_days = optional(number)
    }))
 
    cors = optional(object({
      allowed_origins     = optional(list(string), [])
      support_credentials = optional(bool)
    }))
 
    ip_restrictions = optional(list(object({
      action                    = optional(string)
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      description               = optional(string)
      headers = optional(object({
        x_azure_fdid      = optional(list(string))
        x_fd_health_probe = optional(list(string))
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
    })), [])
 
    scm_ip_restrictions = optional(list(object({
      action                    = optional(string)
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      description               = optional(string)
      headers = optional(object({
        x_azure_fdid      = optional(list(string))
        x_fd_health_probe = optional(list(string))
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
    })), [])
 
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
 
    tags = optional(map(string), {})
  }))
  default = {}
}
*/
