#file
rgVariables = {
  va-avd-rg-prod-1 = {
    rgName     = "rg-avd-osimage-usgovva-p01"
    rgLocation = "usgovvirginia"
    rgTags = {
    }
  }
    va-avd-rg-prod-2 = {
    rgName     = "rg-avd-vm100-usgovva-p01"
    rgLocation = "usgovvirginia"
    rgTags = {
    }
  }
 va-avd-rg-prod-3 = {
    rgName     = "rg-avd-logs-usgovva-p01"
    rgLocation = "usgovvirginia"
    rgTags = {
    }
  }
}
snetVariables = {
  va-avd-snet-prod-1 = {
    vnetrg          = "rg-network-infra-prod"
    vnetname        = "vnet-avd-prod-usgovvirginia"
    snetName        = "snet-avd-hostpool-usgovva-p01"
    snetAddressPrefix = ["10.248.112.0/21"]
  }
  va-avd-snet-prod-2 = {
    vnetrg          = "rg-network-infra-prod"
    vnetname        = "vnet-avd-prod-usgovvirginia"
    snetName        = "snet-avd-osimagebuilder-usgovva-p01"
    snetAddressPrefix = ["10.248.120.48/28"]
  }
  va-avd-snet-prod-3 = {
    vnetrg            = "rg-network-infra-prod"
    vnetname          = "vnet-avd-prod-usgovvirginia"
    snetName          = "snet-avd-privateendpoints-usgovva-p01"
    snetAddressPrefix = ["10.248.120.0/27"]
  }
}
acgVariables = {
  va-avd-acg-prod-1 = {
    name                = "ig_avd_osimage_usgovva_p01"
    resource_group_name = "rg-avd-osimage-usgovva-p01"
    location            = "usgovvirginia"
    description         = "Shared image gallery for AVD images - prod"
  }
}
nsgVariables = {
  va-avd-nsg-prod-1 = {
    name                = "nsg-avd-hostpool-usgovva-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovvirginia"
    security_rules = []
  }
  va-avd-nsg-prod-2 = {
    name                = "nsg-avd-osimagebuilder-usgovva-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovvirginia"
    security_rules = []
  }
  va-avd-nsg-prod-3 = {
    name                = "nsg-avd-privateendpoints-usgovva-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovvirginia"
    security_rules = []
  }
}
nsgSubnetAssociations = {
  va-avd-nsgassoc-prod-1 = {
    nsg_key    = "va-avd-nsg-prod-1"
    subnet_key = "va-avd-snet-prod-1"
  }
  va-avd-nsgassoc-prod-2 = {
    nsg_key    = "va-avd-nsg-prod-2"
    subnet_key = "va-avd-snet-prod-2"
  }
  va-avd-nsgassoc-prod-3 = {
    nsg_key    = "va-avd-nsg-prod-3"
    subnet_key = "va-avd-snet-prod-3"
  }
}
imageDefinitionVariables = {
  va-avd-imagedef-prod-1 = {
    resource_group_name = "rg-avd-osimage-usgovva-p01"
    location            = "usgovvirginia"
    gallery_key = "va-avd-acg-prod-1"
    name = "idf-avd-osimage-w11ss-25h2-usgovva-p01"
    os_type = "Windows"
    trusted_launch_supported = true
    publisher = "MicrosoftWindows"
    offer     = "Windows-11-Enterprise"
    sku       = "2025-H2"
    hyper_v_generation  = "V2"
    accelerated_network_support_enabled = true
  }
}
imageVersionDataVariables = {
  va_avd_img_ver_prod_1 = {
    gallery_key = "va-avd-acg-prod-1"
    rg_key      = "va-avd-rg-prod-1"
    image_name  = "idf-avd-osimage-w11ss-25h2-usgovva-p01"
    version     = "1.0.0"
  }
}
workspaceVariables = {
  va-avd-ws-prod-1 = {
    name                = "wk-avd-vm100-usgovva-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovva-p01"
    location            = "usgovvirginia"
    friendly_name       = "AVD Workspace - US Gov VA Prod P01"
    description         = "AVD Workspace for US Gov VA Prod P01 environment"
    public_network_access_enabled = true
    log_analytics_workspace_key = "va-avd-law-prod-1"
  }
}
hostPoolVariables = {
  va-avd-hp-prod-1 = {
    name                = "hstpl-avd-vm100-usgovva-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovva-p01"
    location            = "usgovvirginia"
    type               = "Personal"
    load_balancer_type = "Persistent"
    friendly_name      = "AVD Host Pool - US Gov VA Prod P01"
    description        = "AVD Host Pool for US Gov VA Prod P01 environment"
    preferred_app_group_type = "Desktop"
    personal_desktop_assignment_type = "Automatic"
    start_vm_on_connect      = true
    validate_environment  = true
    custom_rdp_properties = "quality:i:1;capture:i:1;audiomode:i:0;videoplaybackmode:i:1;audiocapturemode:i:1;enablecredsspsupport:i:1;camerastoredirect:s:*;devicestoredirect:s:;drivestoredirect:s:;redirectclipboard:i:0;redirectcomports:i:0;redirectlocation:i:0;redirectprinters:i:0;redirectsmartcards:i:0;redirectwebauthn:i:0;usbdevicestoredirect:s:;use multimon:i:0;screen mode id:i:1;smart sizing:i:0;dynamic resolution:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;compression:i:1;encode redirected video capture:i:1;redirected video capture encoding quality:i:2;enablerdsaadauth:i:1"
    public_network_access = "EnabledForClientsOnly"
    log_analytics_workspace_key = "va-avd-law-prod-1"
  }
}
privateEndpointVariables = {
  va-avd-pe-hp-prod-1 = {
    name                = "pe-avd-hstpl-vm100-usgovva-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovva-p01"
    location            = "usgovvirginia"
    subnet_key          = "va-avd-snet-prod-3"
    subresource_names   = ["connection"]
    target_type         = "hostpool"
    target_key          = "va-avd-hp-prod-1"
  }
  va-avd-pe-kv-prod-1 = {
    name                = "pe-avd-kv-usgovva-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovva-p01"
    location            = "usgovvirginia"
    subnet_key          = "va-avd-snet-prod-3"
    subresource_names   = ["vault"]
    target_type         = "keyvault"
    target_key          = "va-avd-kv-prod-1"
  }
}
sessionHostVariables = {
  va-avd-sh-prod-1 = {
    hostpool_key         = "va-avd-hp-prod-1"
    prefix               = "EWAPV10001"
    start_index          = 1
    session_host_count   = 3
    deleted_hosts        = []    
    rg_key               = "va-avd-rg-prod-2"
    subnet_key           = "va-avd-snet-prod-1"
    vm_size              = "Standard_NC64as_T4_v3"
    admin_username       = "etn-avd-sessionhost-uname"
    admin_password       = "etn-avd-sessionhost-pass"
    domain_join_username = "etn-avd-domainjoin-uname"
    domain_join_password = "etn-avd-domainjoin-pass"
    domain_name          = "FED.etnfederal.com"
    key_vault_key        = "va-avd-kv-prod-1"
    ou_path              = "OU=Computers,OU=Enterprise Clients-AVDI,DC=FED,DC=etnfederal,DC=com"
    gallery_image_version_key = "va_avd_img_ver_prod_1"
    disk_size_gb              = 1024
    enable_nvidia_gpu_driver = false
    tags = {
      az_res_costcenter = "5100-42358"
    }
  }
    va-avd-sh-prod-2 = {
    hostpool_key         = "va-avd-hp-prod-1"
    prefix               = "EWAPV10001"
    start_index          = 4
    session_host_count   = 15
    deleted_hosts        = ["6","7","8","9","10","12","15","16","17","14"]    
    rg_key               = "va-avd-rg-prod-2"
    subnet_key           = "va-avd-snet-prod-1"
    vm_size              = "Standard_NC16as_T4_v3"
    admin_username       = "etn-avd-sessionhost-uname"
    admin_password       = "etn-avd-sessionhost-pass"
    domain_join_username = "etn-avd-domainjoin-uname"
    domain_join_password = "etn-avd-domainjoin-pass"
    domain_name          = "FED.etnfederal.com"
    key_vault_key        = "va-avd-kv-prod-1"
    ou_path              = "OU=Computers,OU=Enterprise Clients-AVDI,DC=FED,DC=etnfederal,DC=com"
    gallery_image_version_key = "va_avd_img_ver_prod_1"
    disk_size_gb              = 512
    enable_nvidia_gpu_driver = false
    tags = {
      az_res_costcenter = "5100-42358"
    }
  }
  va-avd-sh-prod-3 = {
    hostpool_key         = "va-avd-hp-prod-1"
    prefix               = "EWAPV10001"
    start_index          = 19
    session_host_count   = 1
    deleted_hosts        = ["19"]    
    rg_key               = "va-avd-rg-prod-2"
    subnet_key           = "va-avd-snet-prod-1"
    vm_size              = "Standard_NC64as_T4_v3"
    admin_username       = "etn-avd-sessionhost-uname"
    admin_password       = "etn-avd-sessionhost-pass"
    domain_join_username = "etn-avd-domainjoin-uname"
    domain_join_password = "etn-avd-domainjoin-pass"
    domain_name          = "FED.etnfederal.com"
    key_vault_key        = "va-avd-kv-prod-1"
    ou_path              = "OU=Computers,OU=Enterprise Clients-AVDI,DC=FED,DC=etnfederal,DC=com"
    gallery_image_version_key = "va_avd_img_ver_prod_1"
    disk_size_gb              = 1024
    enable_nvidia_gpu_driver = false
    tags = {
      az_res_costcenter = "5100-42358"
     }
  }
}
applicationGroupVariables = {
  va-avd-ag-prod-1 = {
    name                         = "app-avd-vm100-usgovva-p01"
    resource_group_name          = "rg-avd-vm100-usgovva-p01"
    location                     = "usgovvirginia"
    hostpool_key                 = "va-avd-hp-prod-1"
    type                         = "Desktop"
    friendly_name                = "AVD Desktop App Group - US Gov VA Prod P01"
    description                  = "Desktop application group for the host pool"
    default_desktop_display_name = "Desktop"
    
  }
}

workspaceAssociationVariables = {
  va-avd-wsassoc-prod-1 = {
    workspace_key         = "va-avd-ws-prod-1"
    application_group_key = "va-avd-ag-prod-1"
  }
}

keyVaultVariables = {
  va-avd-kv-prod-1 = {
    name                          = "kv-avd-usgovva-p01"
    resource_group_name           = "rg-avd-vm100-usgovva-p01"
    location                      = "usgovvirginia"
    sku_name                      = "standard"
    rbac_authorization_enabled     = true
    purge_protection_enabled      = true
    soft_delete_retention_days    = 90
    public_network_access_enabled = false
  }
}
logAnalyticsWorkspaceVariables = {
  va-avd-law-prod-1 = {
    name                          = "law-avd-efe-usgovva-p01"
    resource_group_name           = "rg-avd-logs-usgovva-p01"
    location                      = "usgovvirginia"
    sku                           = "PerGB2018"
    retention_in_days             = 30
    daily_quota_gb                = 10
    internet_ingestion_enabled    = true
    internet_query_enabled        = true
    local_authentication_enabled = true
  }
}
scalingPlanVariables = {
  va-avd-sp-prod-1 = {
    name               = "scplan-avd-vm100-usgovva-p01"
    resource_group_key = "va-avd-rg-prod-2"
    location           = "usgovvirginia"
    time_zone          = "Eastern Standard Time"
    hostpool_key       = "va-avd-hp-prod-1"
    friendly_name = "AVD Personal Scaling Plan"
    description   = "Scaling plan for personal host pool"
    exclusion_tag = "eatongov-avdi-excludeFromScaling"
    enabled       = false
    hostPoolType   = "Personal"
    personal_schedules = [
      {
        name         = "Weekdays"
        days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
 
        ramp_up_start_time                    = "06:00"
        ramp_up_auto_start_hosts              = "None"
        ramp_up_start_vm_on_connect           = "Enable"
        ramp_up_action_on_disconnect          = "Deallocate"
        ramp_up_minutes_to_wait_on_disconnect = 90
        ramp_up_action_on_logoff              = "Deallocate"
        ramp_up_minutes_to_wait_on_logoff     = 15

        peak_start_time                    = "08:00"
        peak_start_vm_on_connect           = "Enable"
        peak_action_on_disconnect          = "Deallocate"
        peak_minutes_to_wait_on_disconnect = 90
        peak_action_on_logoff              = "Deallocate"
        peak_minutes_to_wait_on_logoff     = 15

        ramp_down_start_time                    = "18:00"
        ramp_down_start_vm_on_connect           = "Enable"
        ramp_down_action_on_disconnect          = "Deallocate"
        ramp_down_minutes_to_wait_on_disconnect = 90
        ramp_down_action_on_logoff              = "Deallocate"
        ramp_down_minutes_to_wait_on_logoff     = 15

        off_peak_start_time                    = "20:00"
        off_peak_start_vm_on_connect           = "Enable"
        off_peak_action_on_disconnect          = "Deallocate"
        off_peak_minutes_to_wait_on_disconnect = 90
        off_peak_action_on_logoff              = "Deallocate"
        off_peak_minutes_to_wait_on_logoff     = 15
      }
    ]
    # tags = {}
  }
}
dceVariables = {
  va-avd-dce-prod-1 = {
    name                          = "dce-avd-vm100-usgovva-p01"
    resource_group_name           = "rg-avd-logs-usgovva-p01"
    location                      = "usgovvirginia"
    kind                          = "Windows"
    description                   = "Data collection endpoint for AVD session hosts"
    public_network_access_enabled = true
    session_host_keys           = ["va-avd-sh-prod-1", "va-avd-sh-prod-2", "va-avd-sh-prod-3"]
  }
}
dcrVariables = {
  va-avd-dcr-prod-1 = {
    name                        = "dcr-avd-vm100-usgovva-p01"
    resource_group_name         = "rg-avd-logs-usgovva-p01"
    location                    = "usgovvirginia"
    kind                        = "Windows"
    description                 = "Single DCR for all AVD session hosts"
    destination_name            = "law-destination"
    log_analytics_workspace_key = "va-avd-law-prod-1"
    session_host_keys           = ["va-avd-sh-prod-1", "va-avd-sh-prod-2", "va-avd-sh-prod-3"]
    association_description     = "Associate shared DCR to AVD session hosts"
    data_collection_endpoint_key = "va-avd-dce-prod-1"
    data_flows = [
      {
        streams      = ["Microsoft-Perf"]
        destinations = ["law-destination"]
      },
      {
          streams      = ["Microsoft-Event"]
          destinations = ["law-destination"]
      }
    ]
    performance_counters = [
      {
        name                          = "perf-counter-datasource"
        streams                       = ["Microsoft-Perf"]
        sampling_frequency_in_seconds = 60
        counter_specifiers = [
          "\\Processor Information(_Total)\\% Processor Time",
          "\\Memory\\Available Bytes",
          "\\Memory\\% Committed Bytes In Use",
          "\\LogicalDisk(_Total)\\% Free Space",
          "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
          "\\Network Interface(*)\\Bytes Total/sec"
        ]
      }
    ]

    windows_event_logs = [
      {
        name    = "windows-event-datasource"
        streams = ["Microsoft-Event"]
        x_path_queries = [
          "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
          # "System!*[System[(Level=1 or Level=2 or Level=3)]]"
        ]
      }
    ]
  }
}
alertVariables = {
  va-avd-alert-memory-prod-1 = {
    name                 = "alert-avd-memory-usgovva-p01"
    resource_group_name  = "rg-avd-logs-usgovva-p01"
    location             = "usgovvirginia"
    log_analytics_workspace_key  = "va-avd-law-prod-1"
    description          = "Memory > 90% on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys   = ["va-avd-actiongroup-prod-1"]
    criteria = {
        query = <<-QUERY
        Perf
        | where ObjectName == "Memory"
        | where CounterName == "% Committed Bytes In Use"
        | summarize MetricValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
        QUERY
      time_aggregation_method = "Average"
      threshold               = 90
      operator                = "GreaterThan"
      metric_measure_column   = "MetricValue"
      failing_periods = {
        minimum_failing_periods_to_trigger_alert = 3
        number_of_evaluation_periods             = 3
      }
    }
  }
  va-avd-alert-cpu-prod-1 = {
    name                 = "alert-avd-cpu-usgovva-p01"
    resource_group_name  = "rg-avd-logs-usgovva-p01"
    location             = "usgovvirginia"
    log_analytics_workspace_key  = "va-avd-law-prod-1"
    description          = "CPU > 85% for 15 minutes on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys   = ["va-avd-actiongroup-prod-1"]
    criteria = {
      query = <<-QUERY
        Perf
        | where ObjectName == "Processor Information"
        | where CounterName == "% Processor Time"
        | where InstanceName == "_Total"
        | summarize MetricValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
        QUERY
      time_aggregation_method = "Average"
      threshold               = 85
      operator                = "GreaterThan"
      metric_measure_column   = "MetricValue"
      failing_periods = {
        minimum_failing_periods_to_trigger_alert = 3
        number_of_evaluation_periods             = 3
      }
    }
  }
  va-avd-alert-diskfree-prod-1 = {
    name                 = "alert-avd-diskfree-usgovva-p01"
    resource_group_name  = "rg-avd-logs-usgovva-p01"
    location             = "usgovvirginia"
    log_analytics_workspace_key  = "va-avd-law-prod-1"
    description          = "Disk free space < 10% on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
     action_group_keys   = ["va-avd-actiongroup-prod-1"]
    criteria = {
      query = <<-QUERY
      Perf
      | where ObjectName == "LogicalDisk"
      | where CounterName == "% Free Space"
      | where InstanceName == "_Total"
      | summarize MetricValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
      QUERY
      time_aggregation_method = "Average"
      threshold               = 10
      operator                = "LessThan"
      metric_measure_column   = "MetricValue"
      failing_periods = {
        minimum_failing_periods_to_trigger_alert = 3
        number_of_evaluation_periods             = 3
      }
    }
  }
  va-avd-alert-disklatency-prod-1 = {
    name                 = "alert-avd-disklatency-usgovva-p01"
    resource_group_name  = "rg-avd-logs-usgovva-p01"
    location             = "usgovvirginia"
    log_analytics_workspace_key  = "va-avd-law-prod-1"
    description          = "Disk latency > 20 ms on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys   = ["va-avd-actiongroup-prod-1"]
    criteria = {
      query = <<-QUERY
      Perf
      | where ObjectName == "LogicalDisk"
      | where CounterName == "Avg. Disk sec/Transfer"
      | where InstanceName == "_Total"
      | summarize MetricValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
      QUERY
      time_aggregation_method = "Average"
      threshold               = 0.02
      operator                = "GreaterThan"
      metric_measure_column   = "MetricValue"
      failing_periods = {
        minimum_failing_periods_to_trigger_alert = 3
        number_of_evaluation_periods             = 3
      }
    }
  }
  va-avd-alert-network-prod-1 = {
    name                 = "alert-avd-network-usgovva-p01"
    resource_group_name  = "rg-avd-logs-usgovva-p01"
    location             = "usgovvirginia"
    log_analytics_workspace_key  = "va-avd-law-prod-1"
    description          = "Network throughput > 50 MB/s on AVD session hosts"
    severity             = 3
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys   = ["va-avd-actiongroup-prod-1"]
    criteria = {
      query = <<-QUERY
        Perf
        | where ObjectName == "Network Interface"
        | where CounterName == "Bytes Total/sec"
        | summarize MetricValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
        QUERY
      time_aggregation_method = "Average"
      threshold               = 52428800
      operator                = "GreaterThan"
      metric_measure_column   = "MetricValue"
      failing_periods = {
        minimum_failing_periods_to_trigger_alert = 3
        number_of_evaluation_periods             = 3
      }
    }
  }
}
actionGroupVariables = {
  "va-avd-actiongroup-prod-1" = {
    name                = "ag-avd-vm100-usgovva-p01"
    resource_group_name = "rg-avd-logs-usgovva-p01"  
    short_name          = "agavdvap01"
    enabled             = true
    email_receivers = [
      {
        name                    = "List-Enterprise-IT-ECT"
        email_address           = "List-Enterprise-IT-ECT@Eaton.com"
      }]

  }
}
application_group_assignments = {
  "va-avd-group-assignment-1" = {
    application_group_key = "va-avd-ag-prod-1"
    principal_id    = "1ae9da66-9fef-4198-8cd1-cfc782d1dba9"  
    role_definition_name = "Desktop Virtualization User"

  }
}
serviceHealthAlertVariables = {
  "va-avd-service-health-prod-1" = {
    name                = "alert-avd-servicehealth-usgovva-p01"
    resource_group_name = "rg-avd-logs-usgovva-p01"
    description         = "Service Health alert for Virtual Desktop service issues"
    enabled             = true
    # Optional scope override. If omitted, the module uses the current subscription from main.tf.
    # scopes = ["/subscriptions/<subscription-id>"]
    action_group_keys = ["va-avd-actiongroup-prod-1"]
    service_health = {
      events   = ["Incident" 
      # , "Planned Maintenance", "Security Advisory", "Health Advisory"
      ]
      services = ["Windows Virtual Desktop"]
      locations = ["usgovvirginia"]
    }
  }
}

