resource "azurerm_windows_function_app" "windowsFunctionApp" {
  for_each = var.windowsFunctionAppVariables
 
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  service_plan_id     = each.value.service_plan_id
 
  storage_account_name       = try(each.value.storage_account_name, null)
  storage_account_access_key = try(each.value.storage_account_access_key, null)
  storage_uses_managed_identity = try(each.value.storage_uses_managed_identity, null)
  storage_key_vault_secret_id   = try(each.value.storage_key_vault_secret_id, null)
 
  functions_extension_version = try(each.value.functions_extension_version, "~4")
  https_only                  = try(each.value.https_only, true)
  builtin_logging_enabled     = try(each.value.builtin_logging_enabled, true)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)
  key_vault_reference_identity_id = try(each.value.key_vault_reference_identity_id, null)
 
  client_certificate_enabled         = try(each.value.client_certificate_enabled, null)
  client_certificate_mode            = try(each.value.client_certificate_mode, null)
  client_certificate_exclusion_paths = try(each.value.client_certificate_exclusion_paths, null)
  content_share_force_disabled       = try(each.value.content_share_force_disabled, null)
  daily_memory_time_quota            = try(each.value.daily_memory_time_quota, null)
  enabled                            = try(each.value.enabled, null)
  ftp_publish_basic_authentication_enabled      = try(each.value.ftp_publish_basic_authentication_enabled, null)
  virtual_network_backup_restore_enabled        = try(each.value.virtual_network_backup_restore_enabled, null)
  virtual_network_subnet_id                     = try(each.value.virtual_network_subnet_id, null)
  vnet_image_pull_enabled                       = try(each.value.vnet_image_pull_enabled, null)
  webdeploy_publish_basic_authentication_enabled = try(each.value.webdeploy_publish_basic_authentication_enabled, null)
  zip_deploy_file                               = try(each.value.zip_deploy_file, null)
 
  app_settings = try(each.value.set_runtime_app_settings, false) ? merge(
    {
      FUNCTIONS_WORKER_RUNTIME         = try(each.value.functions_worker_runtime, "powershell")
      FUNCTIONS_WORKER_RUNTIME_VERSION = try(each.value.powershell_core_version, "7.4")
    },
    try(each.value.app_settings, {})
  ) : try(each.value.app_settings, {})
 
  dynamic "identity" {
    for_each = try(each.value.identity_type, null) != null || length(try(each.value.identity_ids, [])) > 0 ? [1] : []
    content {
      type         = coalesce(try(each.value.identity_type, null), length(try(each.value.identity_ids, [])) > 0 ? "UserAssigned" : "SystemAssigned")
      identity_ids = length(try(each.value.identity_ids, [])) > 0 ? each.value.identity_ids : null
    }
  }
 
  dynamic "auth_settings" {
    for_each = try(each.value.auth_settings, null) == null ? [] : [each.value.auth_settings]
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, null)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, null)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)
 
      dynamic "active_directory" {
        for_each = try(auth_settings.value.active_directory, null) == null ? [] : [auth_settings.value.active_directory]
        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = try(active_directory.value.allowed_audiences, null)
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }
    }
  }
 
  dynamic "auth_settings_v2" {
    for_each = try(each.value.auth_settings_v2, null) == null ? [] : [each.value.auth_settings_v2]
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, null)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, null)
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, null)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, null)
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, null)
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)
 
      dynamic "active_directory_v2" {
        for_each = try(auth_settings_v2.value.active_directory_v2, null) == null ? [] : [auth_settings_v2.value.active_directory_v2]
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, null)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
        }
      }
 
      dynamic "login" {
        for_each = try(auth_settings_v2.value.login, null) == null ? [] : [auth_settings_v2.value.login]
        content {
          logout_endpoint                   = try(login.value.logout_endpoint, null)
          token_store_enabled               = try(login.value.token_store_enabled, null)
          token_refresh_extension_time      = try(login.value.token_refresh_extension_time, null)
          token_store_path                  = try(login.value.token_store_path, null)
          token_store_sas_setting_name      = try(login.value.token_store_sas_setting_name, null)
          preserve_url_fragments_for_logins = try(login.value.preserve_url_fragments_for_logins, null)
          allowed_external_redirect_urls    = try(login.value.allowed_external_redirect_urls, null)
          cookie_expiration_convention      = try(login.value.cookie_expiration_convention, null)
          cookie_expiration_time            = try(login.value.cookie_expiration_time, null)
          validate_nonce                    = try(login.value.validate_nonce, null)
          nonce_expiration_time             = try(login.value.nonce_expiration_time, null)
        }
      }
    }
  }
 
  dynamic "backup" {
    for_each = try(each.value.backup, null) == null ? [] : [each.value.backup]
    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = try(backup.value.enabled, null)
 
      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = try(backup.value.schedule.keep_at_least_one_backup, null)
        retention_period_days    = try(backup.value.schedule.retention_period_days, null)
        start_time               = try(backup.value.schedule.start_time, null)
      }
    }
  }
 
  dynamic "connection_string" {
    for_each = try(each.value.connection_strings, [])
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
 
  dynamic "sticky_settings" {
    for_each = try(each.value.sticky_settings, null) == null ? [] : [each.value.sticky_settings]
    content {
      app_setting_names       = try(sticky_settings.value.app_setting_names, null)
      connection_string_names = try(sticky_settings.value.connection_string_names, null)
    }
  }
 
  dynamic "storage_account" {
    for_each = try(each.value.storage_accounts, [])
    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }
 
  site_config {
    always_on                              = try(each.value.always_on, false)
    api_definition_url                     = try(each.value.api_definition_url, null)
    api_management_api_id                  = try(each.value.api_management_api_id, null)
    app_command_line                       = try(each.value.app_command_line, null)
    app_scale_limit                        = try(each.value.app_scale_limit, null)
    application_insights_connection_string = try(each.value.application_insights_connection_string, null)
    application_insights_key               = try(each.value.application_insights_key, null)
    default_documents                      = try(each.value.default_documents, null)
    elastic_instance_minimum               = try(each.value.elastic_instance_minimum, null)
    ftps_state                             = try(each.value.ftps_state, "Disabled")
    health_check_path                      = try(each.value.health_check_path, null)
    health_check_eviction_time_in_min      = try(each.value.health_check_eviction_time_in_min, null)
    http2_enabled                          = try(each.value.http2_enabled, true)
    ip_restriction_default_action          = try(each.value.ip_restriction_default_action, null)
    load_balancing_mode                    = try(each.value.load_balancing_mode, null)
    managed_pipeline_mode                  = try(each.value.managed_pipeline_mode, null)
    minimum_tls_version                    = try(each.value.minimum_tls_version, "1.2")
    pre_warmed_instance_count              = try(each.value.pre_warmed_instance_count, null)
    remote_debugging_enabled               = try(each.value.remote_debugging_enabled, null)
    remote_debugging_version               = try(each.value.remote_debugging_version, null)
    runtime_scale_monitoring_enabled       = try(each.value.runtime_scale_monitoring_enabled, null)
    scm_ip_restriction_default_action      = try(each.value.scm_ip_restriction_default_action, null)
    scm_minimum_tls_version                = try(each.value.scm_minimum_tls_version, null)
    minimum_tls_cipher_suite               = try(each.value.minimum_tls_cipher_suite, null)
    scm_use_main_ip_restriction            = try(each.value.scm_use_main_ip_restriction, null)
    use_32_bit_worker                      = try(each.value.use_32_bit_worker, null)
    vnet_route_all_enabled                 = try(each.value.vnet_route_all_enabled, null)
    websockets_enabled                     = try(each.value.websockets_enabled, null)
    worker_count                           = try(each.value.worker_count, null)
 
    application_stack {
      dotnet_version              = try(each.value.application_stack.dotnet_version, null)
      use_dotnet_isolated_runtime = try(each.value.application_stack.use_dotnet_isolated_runtime, null)
      java_version                = try(each.value.application_stack.java_version, null)
      node_version                = try(each.value.application_stack.node_version, null)
      powershell_core_version     = coalesce(try(each.value.application_stack.powershell_core_version, null), try(each.value.powershell_core_version, "7.4"))
      use_custom_runtime          = try(each.value.application_stack.use_custom_runtime, null)
    }
 
    dynamic "app_service_logs" {
      for_each = try(each.value.app_service_logs, null) == null ? [] : [each.value.app_service_logs]
      content {
        disk_quota_mb         = try(app_service_logs.value.disk_quota_mb, null)
        retention_period_days = try(app_service_logs.value.retention_period_days, null)
      }
    }
 
    dynamic "cors" {
      for_each = try(each.value.cors, null) == null ? [] : [each.value.cors]
      content {
        allowed_origins     = try(cors.value.allowed_origins, [])
        support_credentials = try(cors.value.support_credentials, null)
      }
    }
 
    dynamic "ip_restriction" {
      for_each = try(each.value.ip_restrictions, [])
      content {
        action                    = try(ip_restriction.value.action, null)
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.value.name, null)
        priority                  = try(ip_restriction.value.priority, null)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)
 
        dynamic "headers" {
          for_each = try(ip_restriction.value.headers, null) == null ? [] : [ip_restriction.value.headers]
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, null)
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, null)
            x_forwarded_host  = try(headers.value.x_forwarded_host, null)
          }
        }
      }
    }
 
    dynamic "scm_ip_restriction" {
      for_each = try(each.value.scm_ip_restrictions, [])
      content {
        action                    = try(scm_ip_restriction.value.action, null)
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, null)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)
 
        dynamic "headers" {
          for_each = try(scm_ip_restriction.value.headers, null) == null ? [] : [scm_ip_restriction.value.headers]
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, null)
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, null)
            x_forwarded_host  = try(headers.value.x_forwarded_host, null)
          }
        }
      }
    }
  }
 
  dynamic "timeouts" {
    for_each = try(each.value.timeouts, null) == null ? [] : [each.value.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
 
  tags = try(each.value.tags, {})
 
  lifecycle {
    prevent_destroy = true
  }
}