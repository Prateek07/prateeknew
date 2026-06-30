variable "windowsFunctionAppVariables" {
  description = "Map of Windows Function Apps. Optional root and site_config attributes are exposed in the same style as SessionHost."
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    service_plan_id            = string
    storage_account_name       = optional(string)
    storage_account_access_key = optional(string)
    storage_uses_managed_identity = optional(bool)
    storage_key_vault_secret_id   = optional(string)
 
    identity_type = optional(string)
    identity_ids  = optional(list(string), [])
 
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
    ftp_publish_basic_authentication_enabled       = optional(bool)
    virtual_network_backup_restore_enabled         = optional(bool)
    virtual_network_subnet_id                       = optional(string)
    vnet_image_pull_enabled                         = optional(bool)
    webdeploy_publish_basic_authentication_enabled  = optional(bool)
    zip_deploy_file                                = optional(string)
 
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
 
    connection_strings = optional(list(object({
      name  = string
      type  = string
      value = string
    })), [])
 
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
 
    always_on                               = optional(bool, false)
    api_definition_url                      = optional(string)
    api_management_api_id                   = optional(string)
    app_command_line                        = optional(string)
    app_scale_limit                         = optional(number)
    application_insights_connection_string  = optional(string)
    application_insights_key                = optional(string)
    default_documents                       = optional(list(string))
    elastic_instance_minimum                = optional(number)
    ftps_state                              = optional(string, "Disabled")
    health_check_path                       = optional(string)
    health_check_eviction_time_in_min       = optional(number)
    http2_enabled                           = optional(bool, true)
    ip_restriction_default_action           = optional(string)
    load_balancing_mode                     = optional(string)
    managed_pipeline_mode                   = optional(string)
    minimum_tls_version                     = optional(string, "1.2")
    pre_warmed_instance_count               = optional(number)
    remote_debugging_enabled                = optional(bool)
    remote_debugging_version                = optional(string)
    runtime_scale_monitoring_enabled        = optional(bool)
    scm_ip_restriction_default_action       = optional(string)
    scm_minimum_tls_version                 = optional(string)
    minimum_tls_cipher_suite                = optional(string)
    scm_use_main_ip_restriction             = optional(bool)
    use_32_bit_worker                       = optional(bool)
    vnet_route_all_enabled                  = optional(bool)
    websockets_enabled                      = optional(bool)
    worker_count                            = optional(number)
 
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