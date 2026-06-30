#tf.vars file for AVD environment in US Gov Arizona region
rgVariables = {
  az-avd-rg-prod-1 = {
    rgName     = "rg-avd-osimage-usgovaz-p01"
    rgLocation = "usgovarizona"
    rgTags = {
    }
  }
  az-avd-rg-prod-2 = {
    rgName     = "rg-avd-vm100-usgovaz-p01"
    rgLocation = "usgovarizona"
    rgTags = {
    }
  }
  az-avd-rg-prod-3 = {
    rgName     = "rg-avd-logs-usgovaz-p01"
    rgLocation = "usgovarizona"
    rgTags = {
    }
  } 
  az-avd-rg-prod-4 = {
    rgName     = "rg-avd-automation-usgovaz-p01"
    rgLocation = "usgovarizona"
    rgTags = {
    }
  } 
}
# Subnet variables for AVD environment
snetVariables = {
  az-avd-snet-prod-1 = {
    vnetrg          = "rg-network-infra-prod"
    vnetname        = "vnet-avd-prod-usgovarizona"
    snetName        = "snet-avd-hostpool-usgovaz-p01"
    snetAddressPrefix = ["10.248.240.0/21"]
  }
  az-avd-snet-prod-2 = {
    vnetrg          = "rg-network-infra-prod"
    vnetname        = "vnet-avd-prod-usgovarizona"
    snetName        = "snet-avd-osimagebuilder-usgovaz-p01"
    snetAddressPrefix = ["10.248.248.48/28"]
  }
  az-avd-snet-prod-3 = {
    vnetrg            = "rg-network-infra-prod"
    vnetname          = "vnet-avd-prod-usgovarizona"
    snetName          = "snet-avd-privateendpoints-usgovaz-p01"
    snetAddressPrefix = ["10.248.248.0/27"]
  }
}
# Network Security Group variables for AVD environment
nsgVariables = {
  az-avd-nsg-prod-1 = {
    name                = "nsg-avd-hostpool-usgovaz-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovarizona"
    security_rules = []
  }
  az-avd-nsg-prod-2 = {
    name                = "nsg-avd-osimagebuilder-usgovaz-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovarizona"
    security_rules = []
  }
  az-avd-nsg-prod-3 = {
    name                = "nsg-avd-privateendpoints-usgovaz-p01"
    resource_group_name = "rg-network-infra-prod"
    location            = "usgovarizona"
    security_rules = []
  }
}
# Network Security Group to Subnet Association variables for AVD environment
nsgSubnetAssociations = {
  az-avd-nsgassoc-prod-1 = {
    nsg_key    = "az-avd-nsg-prod-1"
    subnet_key = "az-avd-snet-prod-1"
  }
  az-avd-nsgassoc-prod-2 = {
    nsg_key    = "az-avd-nsg-prod-2"
    subnet_key = "az-avd-snet-prod-2"
  }
  az-avd-nsgassoc-prod-3 = {
    nsg_key    = "az-avd-nsg-prod-3"
    subnet_key = "az-avd-snet-prod-3"
  }
}
# Workspace variables for AVD environment
workspaceVariables = {
  az-avd-ws-prod-1 = {
    name                = "wk-avd-vm100-usgovaz-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovaz-p01"
    location            = "usgovarizona"
    friendly_name       = "AVD Workspace - US Gov AZ Prod P01"
    description         = "AVD Workspace for US Gov AZ Prod P01 environment"
    public_network_access_enabled = true
    log_analytics_workspace_key = "az-avd-law-prod-1"
  }
}
# Host Pool variables for AVD environment
hostPoolVariables = {
  az-avd-hp-prod-1 = {
    name                = "hstpl-avd-vm100-usgovaz-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovaz-p01"
    location            = "usgovarizona"
    type               = "Personal"
    load_balancer_type = "Persistent"
    friendly_name      = "AVD Host Pool - US Gov AZ Prod P01"
    description        = "AVD Host Pool for US Gov AZ Prod P01 environment"
    preferred_app_group_type = "Desktop"
    personal_desktop_assignment_type = "Automatic"
    start_vm_on_connect      = true
    validate_environment  = true
    custom_rdp_properties = "quality:i:1;capture:i:1;audiomode:i:0;videoplaybackmode:i:1;audiocapturemode:i:1;enablecredsspsupport:i:1;camerastoredirect:s:*;devicestoredirect:s:;drivestoredirect:s:;redirectclipboard:i:0;redirectcomports:i:0;redirectlocation:i:0;redirectprinters:i:0;redirectsmartcards:i:0;redirectwebauthn:i:0;usbdevicestoredirect:s:;use multimon:i:0;screen mode id:i:1;smart sizing:i:0;dynamic resolution:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;compression:i:1;encode redirected video capture:i:1;redirected video capture encoding quality:i:2;enablerdsaadauth:i:1"
    public_network_access = "EnabledForClientsOnly"
    log_analytics_workspace_key = "az-avd-law-prod-1"
  }
}
# Private Endpoint variables for AVD environment
privateEndpointVariables = {
  az-avd-pe-hp-prod-1 = {
    name                = "pe-avd-hstpl-vm100-usgovaz-p01-pr01"
    resource_group_name = "rg-avd-vm100-usgovaz-p01"
    location            = "usgovarizona"
    subnet_key          = "az-avd-snet-prod-3"
    subresource_names   = ["connection"]
    target_type         = "hostpool"
    target_key          = "az-avd-hp-prod-1"
  }

  az-avd-pe-kv-prod-1 = {
    name                = "pe-avd-kv-usgovaz-p01"
    resource_group_name = "rg-avd-vm100-usgovaz-p01"
    location            = "usgovarizona"
    subnet_key          = "az-avd-snet-prod-3"
    subresource_names   = ["vault"]
    target_type         = "keyvault"
    target_key          = "az-avd-kv-prod-1"
  }
  az-avd-pe-blob-prod-1 = {
    name                = "pe-avd-stblob-automation-usgovaz-p01"
    resource_group_name = "rg-avd-automation-usgovaz-p01"
    location            = "usgovarizona"
    subnet_key          = "az-avd-snet-prod-3"
    subresource_names   = ["blob"]
    target_type         = "storageaccount"
    target_key          = "az-avd-sa-prod-1"
  }
  az-avd-pe-file-prod-1 = {
    name                = "pe-avd-stfile-automation-usgovaz-p01"
    resource_group_name = "rg-avd-automation-usgovaz-p01"
    location            = "usgovarizona"
    subnet_key          = "az-avd-snet-prod-3"
    subresource_names   = ["file"]
    target_type         = "storageaccount"
    target_key          = "az-avd-sa-prod-1"
  }
  #  az-avd-pe-func-prod-1 = {
  #   name                = "pe-avd-func-automation-usgovaz-p01"
  #   resource_group_name = "rg-avd-automation-usgovaz-p01"
  #   location            = "usgovarizona"
  #   subnet_key          = "az-avd-snet-prod-3"
  #   subresource_names   = ["sites"]
  #   target_type         = "functionapp"
  #   target_key          = "az-avd-fa-prod-1"
  #}

}
# Application Group variables for AVD environment
applicationGroupVariables = {
  az-avd-ag-prod-1 = {
    name                         = "app-avd-vm100-usgovaz-p01"
    resource_group_name          = "rg-avd-vm100-usgovaz-p01"
    location                     = "usgovarizona"
    hostpool_key                 = "az-avd-hp-prod-1"
    type                         = "Desktop"
    friendly_name                = "AVD Desktop App Group - US Gov AZ Prod P01"
    description                  = "Desktop application group for the host pool"
    default_desktop_display_name = "Desktop"
  }
}
# Workspace Application Group Association variables for AVD environment
workspaceAssociationVariables = {
  az-avd-wsassoc-prod-1 = {
    workspace_key         = "az-avd-ws-prod-1"
    application_group_key = "az-avd-ag-prod-1"
  }
}
# Log Analytics Workspace variables for AVD environment
logAnalyticsWorkspaceVariables = {
  az-avd-law-prod-1 = {
    name                          = "law-avd-efe-usgovaz-p01"
    resource_group_name           = "rg-avd-logs-usgovaz-p01"
    location                      = "usgovarizona"
    sku                           = "PerGB2018"
    retention_in_days             = 30
    daily_quota_gb                = 10
    internet_ingestion_enabled    = true
    internet_query_enabled        = true
    local_authentication_enabled = true
  }
}
# key Vault variables for AVD environment
keyVaultVariables = {
  az-avd-kv-prod-1 = {
    name                          = "kv-avd-usgovaz-p01"
    resource_group_name           = "rg-avd-vm100-usgovaz-p01"
    location                      = "usgovarizona"
    sku_name                      = "standard"
    rbac_authorization_enabled     = true
    purge_protection_enabled      = true
    soft_delete_retention_days    = 90
    public_network_access_enabled = false
  }
}
# Shared Image Gallery and Image Definition variables for AVD environment
acgVariables = {
  az-avd-acg-prod-1 = {
    name                = "ig_avd_osimage_usgovaz_p01"
    resource_group_name = "rg-avd-osimage-usgovaz-p01"
    location            = "usgovarizona"
    description         = "Shared image gallery for AVD images - prod"
  }
}
# Image Definition variables for AVD environment
imageDefinitionVariables = {
  az-avd-imagedef-prod-1 = {
    resource_group_name = "rg-avd-osimage-usgovaz-p01"
    location            = "usgovarizona"
    gallery_key = "az-avd-acg-prod-1"
    name = "idf-avd-osimage-w11ss-25h2-usgovaz-p01"
    os_type = "Windows"
    trusted_launch_supported = true
    publisher = "MicrosoftWindows"
    offer     = "Windows-11-Enterprise"
    sku       = "2025-H2"
    hyper_v_generation  = "V2"
    accelerated_network_support_enabled = true
  }
  az-avd-imagedef-prod-2 = {
    resource_group_name = "rg-avd-osimage-usgovaz-p01"
    location            = "usgovarizona"
    gallery_key = "az-avd-acg-prod-1"
    name = "idf-avd-win11-25h2-nvadsa10-usgovaz-p01"
    os_type = "Windows"
    trusted_launch_enabled = true
    publisher = "MicrosoftWindows"
    offer     = "Win-11-25h2"
    sku       = "nvadsa10"
    hyper_v_generation  = "V2"
    accelerated_network_support_enabled = true
  }

  az-avd-imagedef-prod-3 = {
    resource_group_name = "rg-avd-osimage-usgovaz-p01"
    location            = "usgovarizona"
    gallery_key = "az-avd-acg-prod-1"
    name = "idf-avd-win11-25h2-ncast4-usgovaz-p01"
    os_type = "Windows"
    trusted_launch_enabled = true
    publisher = "MicrosoftWindows"
    offer     = "Win-11-25h2"
    sku       = "ncast4"
    hyper_v_generation  = "V2"
    accelerated_network_support_enabled = true
  }
}
# Image Version Data variables for AVD environment
imageVersionDataVariables = {
  az-avd-img-ver-prod-1 = {
    gallery_key = "az-avd-acg-prod-1"
    rg_key      = "az-avd-rg-prod-1"
    image_name  = "idf-avd-osimage-w11ss-25h2-usgovaz-p01"
    version     = "1.0.0"
  }
  az-avd-img-ver-prod-2 = {
    gallery_key = "az-avd-acg-prod-1"
    rg_key      = "az-avd-rg-prod-1"
    image_name  = "idf-avd-win11-25h2-nvadsa10-usgovaz-p01"
    version     = "1.0.0"
  }
}
# Session Host variables for AVD environment
sessionHostVariables = {
  az-avd-sh-prod-4= {
    hostpool_key         = "az-avd-hp-prod-1"
    prefix               = "EWV0010001"
    start_index          = 1
    session_host_count   = 22
    deleted_hosts        = ["20", "21"] 
    rg_key               = "az-avd-rg-prod-2"
    subnet_key           = "az-avd-snet-prod-1"
    vm_size              = "Standard_NV18ads_A10_v5"
    admin_username       = "etn-avd-sessionhost-uname"
    admin_password       = "etn-avd-sessionhost-pass"
    domain_join_username = "etn-avd-domainjoin-uname"
    domain_join_password = "etn-avd-domainjoin-pass"
    domain_name          = "FED.etnfederal.com"
    key_vault_key        = "az-avd-kv-prod-1"
    ou_path              = "OU=Computers,OU=Enterprise Clients-AVDI,DC=FED,DC=etnfederal,DC=com"
    gallery_image_version_key = "az-avd-img-ver-prod-2"
    disk_size_gb              = 512
    enable_nvidia_gpu_driver = true
    vtpm_enabled = true
    secure_boot_enabled = true
    tags = {
      az_res_costcenter = "5100-42358"
    }
  }
  az-avd-sh-prod-5= {
    hostpool_key         = "az-avd-hp-prod-1"
    prefix               = "EWV0210001"
    start_index          = 1
    session_host_count   = 1
    deleted_hosts        = [] 
    rg_key               = "az-avd-rg-prod-2"
    subnet_key           = "az-avd-snet-prod-1"
    vm_size              = "Standard_NV36ads_A10_v5"
    admin_username       = "etn-avd-sessionhost-uname"
    admin_password       = "etn-avd-sessionhost-pass"
    domain_join_username = "etn-avd-domainjoin-uname"
    domain_join_password = "etn-avd-domainjoin-pass"
    domain_name          = "FED.etnfederal.com"
    key_vault_key        = "az-avd-kv-prod-1"
    ou_path              = "OU=Computers,OU=Enterprise Clients-AVDI,DC=FED,DC=etnfederal,DC=com"
    gallery_image_version_key = "az-avd-img-ver-prod-2"
    disk_size_gb              = 512
    enable_nvidia_gpu_driver = true
    vtpm_enabled = true
    secure_boot_enabled = true
    tags = {
      az_res_costcenter = "5100-42358"
    }
  }
}
# Scaling Plan variables for AVD environment
scalingPlanVariables = {
  az-avd-sp-prod-1 = {
    name               = "scplan-avd-vm100-usgovaz-p01"
    resource_group_key = "az-avd-rg-prod-2"
    location           = "usgovarizona"
    time_zone          = "Eastern Standard Time"
    hostpool_key       = "az-avd-hp-prod-1"
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
    tags          = {}
    
  }
}
# DCE  variables for AVD environment
dceVariables = {
  az-avd-dce-prod-1 = {
    name                          = "dce-avd-vm100-usgovaz-p01"
    resource_group_name           = "rg-avd-logs-usgovaz-p01"
    location                      = "usgovarizona"
    kind                          = "Windows"
    description                   = "Data collection endpoint for AVD session hosts"
    public_network_access_enabled = true
    session_host_keys           = ["az-avd-sh-prod-4", "az-avd-sh-prod-5"]
  }
}
# DCR variables for AVD environment
dcrVariables = {
  az-avd-dcr-prod-1 = {
    name                        = "dcr-avd-vm100-usgovaz-p01"
    resource_group_name         = "rg-avd-logs-usgovaz-p01"
    location                    = "usgovarizona"
    kind                        = "Windows"
    description                 = "Single DCR for all AVD session hosts"
    destination_name            = "law-destination"
    log_analytics_workspace_key = "az-avd-law-prod-1"
    session_host_keys           = ["az-avd-sh-prod-4", "az-avd-sh-prod-5"]
    association_description     = "Associate shared DCR to AVD session hosts"
    data_collection_endpoint_key = "az-avd-dce-prod-1"
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
# Alert variables for AVD environment
alertVariables = {
  az-avd-alert-memory-prod-1 = {
    name                 = "alert-avd-memory-usgovaz-p01"
    resource_group_name  = "rg-avd-logs-usgovaz-p01"
    location             = "usgovarizona"
    log_analytics_workspace_key  = "az-avd-law-prod-1"
    description          = "Memory > 90% on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys = ["az-avd-actiongroup-prod-1"]
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
  az-avd-alert-cpu-prod-1 = {
    name                 = "alert-avd-cpu-usgovaz-p01"
    resource_group_name  = "rg-avd-logs-usgovaz-p01"
    location             = "usgovarizona"
    log_analytics_workspace_key  = "az-avd-law-prod-1"
    description          = "CPU > 85% for 15 minutes on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys = ["az-avd-actiongroup-prod-1"]
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
  az-avd-alert-diskfree-prod-1 = {
    name                 = "alert-avd-diskfree-usgovaz-p01"
    resource_group_name  = "rg-avd-logs-usgovaz-p01"
    location             = "usgovarizona"
    log_analytics_workspace_key  = "az-avd-law-prod-1"
    description          = "Disk free space < 10% on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys = ["az-avd-actiongroup-prod-1"]
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
  az-avd-alert-disklatency-prod-1 = {
    name                 = "alert-avd-disklatency-usgovaz-p01"
    resource_group_name  = "rg-avd-logs-usgovaz-p01"
    location             = "usgovarizona"
    log_analytics_workspace_key  = "az-avd-law-prod-1"
    description          = "Disk latency > 20 ms on AVD session hosts"
    severity             = 2
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys = ["az-avd-actiongroup-prod-1"]
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
  az-avd-alert-network-prod-1 = {
    name                 = "alert-avd-network-usgovaz-p01"
    resource_group_name  = "rg-avd-logs-usgovaz-p01"
    location             = "usgovarizona"
    log_analytics_workspace_key  = "az-avd-law-prod-1"
    description          = "Network throughput > 50 MB/s on AVD session hosts"
    severity             = 3
    evaluation_frequency = "PT5M"
    window_duration      = "PT15M"
    action_group_keys = ["az-avd-actiongroup-prod-1"]
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
# Action Group variables for AVD environment
actionGroupVariables = {
  "az-avd-actiongroup-prod-1" = {
    name                = "ag-avd-vm100-usgovaz-p01"
    resource_group_name = "rg-avd-logs-usgovaz-p01"  
    short_name          = "agavdazp01"
    enabled             = true
    email_receivers = [
      {
        name                    = "List-Enterprise-IT-ECT"
        email_address           = "List-Enterprise-IT-ECT@Eaton.com"
      }]
  }
}
# Application Group Assignment variables for AVD environment
application_group_assignments = {
  "az-avd-group-assignment-1" = {
    application_group_key = "az-avd-ag-prod-1"
    principal_id    = "247e4ca6-0c26-4461-adb1-eeb03d71d586"
    role_definition_name = "Desktop Virtualization User"
  }
}
# Service Health Alert variables for AVD environment
serviceHealthAlertVariables = {
  "az-avd-service-health-prod-1" = {
    name                = "alert-avd-servicehealth-usgovaz-p01"
    resource_group_name = "rg-avd-logs-usgovaz-p01"
    description         = "Service Health alert for Virtual Desktop service issues"
    enabled             = true
    # Optional scope override. If omitted, the module uses the current subscription from main.tf.
    # scopes = ["/subscriptions/<subscription-id>"]
    action_group_keys = ["az-avd-actiongroup-prod-1"]
    service_health = {
      events   = ["Incident" 
      # , "Planned Maintenance", "Security Advisory", "Health Advisory"
      ]
      services = ["Windows Virtual Desktop"]
      locations = ["usgovarizona"]
    }
  }
}

# Vm Lifecycle Automation Managed Identity variables for AVD environment
# This managed identity will be used by the Azure Function App to perform cleanup of AVD session hosts in the environment.
mIdentity = {
  az-avd-mi-prod-1 = {
    miName          = "uami-avd-automation-usgovaz-p01"
    miResourceGroup = "rg-avd-automation-usgovaz-p01"
    miLocation      = "usgovarizona"
    tags            = {}
  }
}

serviceBusNamespaceVariables = {
  az-avd-sbm-prod-1 = {
    name                          = "sbns-avd-automation-usgovaz-p01"
    resource_group_name           = "rg-avd-automation-usgovaz-p01"
    location                      = "usgovarizona"
    sku                           = "Standard"
    minimum_tls_version           = "1.2"
    local_auth_enabled            = true
    public_network_access_enabled = false
    tags                          = {}
  }
}
serviceBusQueueVariables = {
  az-avd-sbq-prod-1 = {
    name                                 = "sbq-avd-automation-vmld-usgovaz-p01"
    namespace_key                        = "az-avd-sbm-prod-1"
    max_delivery_count                   = 5
    default_message_ttl                  = "P14D"
    dead_lettering_on_message_expiration = true
  }
}
applicationInsightsVariables = {
  az-avd-appi-prod-1 = {
    name                        = "appi-avd-automation-usgovaz-p01"
    resource_group_name         = "rg-avd-automation-usgovaz-p01"
    location                    = "usgovarizona"
    application_type            = "web"
    log_analytics_workspace_key = "az-avd-law-prod-1"
    tags                        = {}
  }
}
appServicePlanVariables = {
  az-avd-asp-prod-1 = {
    name                = "asp-avd-automation-usgovaz-p01"
    resource_group_name = "rg-avd-automation-usgovaz-p01"
    location            = "usgovarizona"
    os_type             = "Windows"
    sku_name            = "EP1"
    tags                = {}
  }
}
storageAccountVariables = {
  az-avd-sa-prod-1 = {
    name                            = "stavdfausgovazp01"
    resource_group_name             = "rg-avd-automation-usgovaz-p01"
    location                        = "usgovarizona"
    account_kind                    = "StorageV2"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    access_tier                     = "Hot"
    min_tls_version                 = "TLS1_2"
    https_traffic_only_enabled      = true
    allow_nested_items_to_be_public = false
    shared_access_key_enabled       = true
    public_network_access_enabled   = false
    tags                            = {}
  }
}

eventGridSystemTopicVariables = {
  az-avd-egst-prod-1 = {
    name                      = "egst-avd-automation-usgovaz-p01"
    resource_group_name       = "rg-avd-automation-usgovaz-p01"
    location                  = "Global"
    source_resource_group_key = "az-avd-rg-prod-4"
    topic_type                = "Microsoft.Resources.ResourceGroups"
    identity_key              = "az-avd-mi-prod-1"
    tags                      = {}
  }
}
 
eventGridSubscriptionVariables = {
  az-avd-egs-prod-1 = {
    name                  = "egs-avd-automation-usgovaz-p01"
    resource_group_name   = "rg-avd-automation-usgovaz-p01"
    system_topic_key      = "az-avd-egst-prod-1"
    service_bus_queue_key = "az-avd-sbq-prod-1"
    delivery_identity_key = "az-avd-mi-prod-1"
    included_event_types  = ["Microsoft.Resources.ResourceDeleteSuccess"]
    operation_names       = ["Microsoft.Compute/virtualMachines/delete"]
    max_delivery_attempts = 10
    event_time_to_live    = 1440
    labels                = ["avd", "entra-cleanup"]
  }
}


# windowsFunctionAppVariables = {
#   az-avd-fa-prod-1 = {
#     name                          = "func-avd-automation-usgovaz-p01"
#     resource_group_name           = "rg-avd-automation-usgovaz-p01"
#     location                      = "usgovarizona"
#     app_service_plan_key          = "az-avd-asp-prod-1"
#     storage_account_key           = "az-avd-sa-prod-1"
#     managed_identity_key          = "az-avd-mi-prod-1"
#     service_bus_namespace_key     = "az-avd-sbm-prod-1"
#     service_bus_queue_key         = "az-avd-sbq-prod-1"
#     application_insights_resource_key = "az-avd-appi-prod-1"
#     set_runtime_app_settings      = true
#     powershell_core_version       = "7.6"
#     functions_extension_version   = "~4"
#     https_only                    = true
#     public_network_access_enabled = false
#     app_settings = {
#       GRAPH_ROOT          = "https://graph.microsoft.us/v1.0"
#       GRAPH_RESOURCE      = "https://graph.microsoft.us"
#       ALLOWED_VM_PREFIXES = ""
#       DRY_RUN             = "true"
#       WEBSITE_RUN_FROM_PACKAGE = "1"
#     }
#     tags = {}
#   }
# }
