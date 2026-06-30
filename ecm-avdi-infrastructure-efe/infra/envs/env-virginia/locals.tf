data "azurerm_client_config" "current" {}
locals{
    snetVariableslocal={
        for key, value in var.snetVariables : key => {
            vnetname = data.azurerm_virtual_network.vnet[key].name
            vnetrg   = data.azurerm_virtual_network.vnet[key].resource_group_name
            snetName = value.snetName
            snetAddressPrefix = value.snetAddressPrefix
        }
    }

    nsgSubnetAssociations = {
        for key, value in var.nsgSubnetAssociations : key => {
            nsg_id = module.NetworkSecurityGroup.nsg[value.nsg_key].id
            snet_id = module.Subnet.snet[value.subnet_key].id
        }
    }
    imageDefinitionVariables = {
        for key, value in var.imageDefinitionVariables : key => merge(value, {
            gallery_name = module.ComputeGallery.acg[value.gallery_key].name
        })
    }

  # privateEndpointTargetIds = {
  #   hostpool = { for k, v in module.Hostpool.hostpool : k => v.id }
  #   keyvault = { for k, v in module.Keyvault.Keyvault : k => v.id }
  # }

 
  privateEndpointTargetIds = {
    hostpool = {
      for k, v in var.hostPoolVariables :
      k => "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.DesktopVirtualization/hostPools/${v.name}"
    }
    keyvault = { for k, v in module.Keyvault.Keyvault : k => v.id }
  }
 
  privateEndpointVariables = {
    for key, value in var.privateEndpointVariables : key => {
      resource_group_name            = value.resource_group_name
      location                       = value.location
      subnet_id                      = module.Subnet.snet[value.subnet_key].id
      name                           = value.name
      subresource_names              = value.subresource_names
      private_connection_resource_id = local.privateEndpointTargetIds[value.target_type][value.target_key]
      private_dns_zone_ids           = try(value.private_dns_zone_ids, [])
      tags                           = try(value.tags, {})
    }
  }

  diagnosticSettings = merge([
    for type, config in {
      hostpool  = { vars = var.hostPoolVariables,  module = module.Hostpool.hostpool }
      workspace = { vars = var.workspaceVariables, module = module.Workspace.Workspace }
    } : {
      for key, value in config.vars : "${type}-${key}" => {
        name                           = "${value.name}-diag"
        target_resource_id             = config.module[key].id
        log_analytics_workspace_id     = module.LogAnalyticsWorkspace.LogAnalyticsWorkspace[value.log_analytics_workspace_key].id
        log_analytics_destination_type = "Dedicated"
      }
      if try(value.log_analytics_workspace_key, null) != null
    }]...)

  imageVersionDataVariablesResolved = {
    for key, value in var.imageVersionDataVariables : key => {
      gallery_name        = module.ComputeGallery.acg[value.gallery_key].name
      resource_group_name = module.ResourceGroup.rg[value.rg_key].name
      image_name          = value.image_name
      version             = value.version
    }
  }
generated_session_hosts = merge([
    for sh_key, sh_value in var.sessionHostVariables : {
      for i in range(sh_value.session_host_count) :
      "${sh_key}-${sh_value.start_index + i}" => {
        session_host_key             = sh_key
        host_number                  = tostring(sh_value.start_index + i)
        prefix                       = sh_value.prefix
        vm_name                      = format("%s-%d", sh_value.prefix, sh_value.start_index + i)
        hostpool_key                 = sh_value.hostpool_key
        rg_key                       = sh_value.rg_key
        subnet_key                   = sh_value.subnet_key
        vm_size                      = sh_value.vm_size
        domain_name                  = sh_value.domain_name
        admin_username               = try(data.azurerm_key_vault_secret.session_host_admin_username[sh_key].value, sh_value.admin_username, null)
        admin_password               = try(data.azurerm_key_vault_secret.session_host_admin_password[sh_key].value, sh_value.admin_password, null)
        domain_join_username         = try(data.azurerm_key_vault_secret.session_host_domain_join_username[sh_key].value, sh_value.domain_join_username, null)
        domain_join_password         = try(data.azurerm_key_vault_secret.session_host_domain_join_password[sh_key].value, sh_value.domain_join_password, null)
        key_vault_key                = try(sh_value.key_vault_key, null)
        ou_path                      = try(sh_value.ou_path, null)
        tags                         = try(sh_value.tags, {})
        os_disk_storage_account_type = try(sh_value.os_disk_storage_account_type, "Premium_LRS")
        disk_size_gb              = try(sh_value.disk_size_gb, null)
        gallery_image_version_key    = try(sh_value.gallery_image_version_key, null)
        source_image_reference       = try(sh_value.source_image_reference, null)
        enable_nvidia_gpu_driver = try(sh_value.enable_nvidia_gpu_driver, false)
      }
      if !contains(try(sh_value.deleted_hosts, []), tostring(sh_value.start_index + i))
    }
  ]...)
  nicVariables = {
    for key, value in local.generated_session_hosts : key => {
      name                          = "${value.vm_name}-nic"
      resource_group_name           = module.ResourceGroup.rg[value.rg_key].name
      location                      = module.ResourceGroup.rg[value.rg_key].location
      subnet_id                     = module.Subnet.snet[value.subnet_key].id
      private_ip_address_allocation = "Dynamic"
      tags                          = try(value.tags, {})
    }
  }
  session_hosts_resolved = {
    for key, value in local.generated_session_hosts : key => {
      vm_name                      = value.vm_name
      location                     = module.ResourceGroup.rg[value.rg_key].location
      resource_group_name          = module.ResourceGroup.rg[value.rg_key].name
      network_interface_ids        = [module.NetworkInterface.nic[key].id]
      hostpool_name                = module.Hostpool.hostpool[value.hostpool_key].name
      hostpool_key                 = value.hostpool_key
      vm_size                      = value.vm_size
      admin_username               = value.admin_username
      admin_password               = value.admin_password
      domain_name                  = value.domain_name
      domain_join_username         = value.domain_join_username
      domain_join_password         = value.domain_join_password
      ou_path                      = value.ou_path
      tags                         = try(value.tags, {})
      os_disk_storage_account_type = value.os_disk_storage_account_type
      disk_size_gb              = value.disk_size_gb
      enable_nvidia_gpu_driver = try(value.enable_nvidia_gpu_driver, false)
      source_image_id = (
        value.gallery_image_version_key != null
        ? module.ComputeGalleryImageVersionData.image_version[value.gallery_image_version_key].id
        : null
      )
      source_image_reference = value.source_image_reference
    }
  }
  unregister_session_hosts = {
    for key, value in local.generated_session_hosts : key => {
      hostpool_key      = value.hostpool_key
      registration_name = "${value.vm_name}.${value.domain_name}"
    }
  }
  hostpoolRegistrationVariables = {
    for hostpool_key in distinct([
      for _, value in var.sessionHostVariables : value.hostpool_key
    ]) : hostpool_key => module.Hostpool.hostpool[hostpool_key].id
  }

dceVariablesResolved = {
    for key, value in var.dceVariables : key => value
  }
  dceAssociationVariablesResolved = merge([
    for dce_key, dce_value in var.dceVariables : {
      for session_host_resource_key, session_host_resource in module.SessionHost.sessionHost :
      "${dce_key}-${session_host_resource_key}" => {
        name                        = "configurationAccessEndpoint"
        target_resource_id          = session_host_resource.id
        data_collection_endpoint_id = module.DCE.dce[dce_key].id
        description                 = try(dce_value.association_description, "DCE association to session host VM")
      }
      if anytrue([
        for session_host_key in try(dce_value.session_host_keys, []) :
        startswith(session_host_resource_key, "${session_host_key}-")
      ])
    }
  ]...)
  dcrVariablesResolved = {
    for key, value in var.dcrVariables : key => merge(
      value,
      {
        log_analytics_workspace_id = module.LogAnalyticsWorkspace.LogAnalyticsWorkspace[value.log_analytics_workspace_key].id
        data_collection_endpoint_id = try(module.DCE.dce[value.data_collection_endpoint_key].id, null)
      }
    )
  }
 
dcrAssociationVariablesResolved = merge([
  for dcr_key, dcr_value in var.dcrVariables : {
    for session_host_resource_key, session_host_resource in module.SessionHost.sessionHost :
    "${dcr_key}-${session_host_resource_key}" => {
      name                    = "dcr-${session_host_resource.name}-assoc"
      target_resource_id      = session_host_resource.id
      data_collection_rule_id = module.DCR.dcr[dcr_key].id
      description             = try(dcr_value.association_description, "DCR association to session host VM")
    }
    if anytrue([
      for session_host_key in dcr_value.session_host_keys :
      startswith(session_host_resource_key, "${session_host_key}-")
    ])
  }
]...)

}

