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
    trusted_launch_supported = bool
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
    enable_nvidia_gpu_driver = optional(bool, false)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    }))
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
    data_collection_endpoint_key = optional(string)
    association_description     = optional(string)
    tags                        = optional(map(string), {})
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
    tags                 = optional(map(string), {})
 
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
    tags                = optional(map(string), {})
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
 
