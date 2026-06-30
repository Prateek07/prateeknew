data "azurerm_client_config" "current" {}
 
module "ResourceGroup" {
  source     = "../../modules/ResourceGroup"
  rgVariables = var.rgVariables
}

module "Subnet" {
  source = "../../modules/Subnet"
  snetVariables = local.snetVariableslocal
}

module "NetworkSecurityGroup" {
  source = "../../modules/NetworkSecurityGroup"
  nsgVariables = var.nsgVariables
    depends_on = [
     module.Subnet
  ]
}
 
module "nsgSubnetAssociation" {
  source = "../../modules/nsgSubnetAssociation"
  nsgSubnetAssociations = local.nsgSubnetAssociations
  depends_on = [
    module.NetworkSecurityGroup,
    module.Subnet
  ]
}
module "Workspace" {
  source = "../../modules/Workspace"
  workspaceVariables = var.workspaceVariables
  depends_on = [ module.ResourceGroup ]
}

module "Hostpool" {
  source = "../../modules/Hostpool"
  hostPoolVariables = var.hostPoolVariables
  depends_on = [
    # module.ResourceGroup
  ]
}
module "PrivateEndPoint" {
  source = "../../modules/PrivateEndPoint"
  privateEndpointVariables = local.privateEndpointVariables
  depends_on = [
    module.Hostpool,
    module.ResourceGroup, module.Subnet
  ]
}
module "ApplicationGroup" {
  source                    = "../../modules/ApplicationGroup"
  applicationGroupVariables = var.applicationGroupVariables
  hostpool_ids              = { for k, v in module.Hostpool.hostpool : k => v.id }
  depends_on = [
    module.Hostpool, module.ResourceGroup
  ]
}
module "WorkspaceApplicationGroupAssociation" {
  source                       = "../../modules/WorkspaceAppGroupAssociation"
  workspaceAssociationVariables = var.workspaceAssociationVariables
  workspace_ids                = { for k, v in module.Workspace.Workspace : k => v.id }
  application_group_ids        = { for k, v in module.ApplicationGroup.applicationGroup : k => v.id }
  depends_on = [
    module.Workspace,
    module.ApplicationGroup, module.ResourceGroup
  ]
}
module "DiagnosticSetting" {
  source              = "../../modules/DiagnosticSetting"
  diagnostic_settings = local.diagnosticSettings
  depends_on = [
    module.Hostpool,module.Workspace,
    module.LogAnalyticsWorkspace, module.ResourceGroup
  ]

}
module "LogAnalyticsWorkspace" {
  source                        = "../../modules/LogAnalyticsWorkspace"
  logAnalyticsWorkspaceVariables = var.logAnalyticsWorkspaceVariables
  depends_on = [
    module.ResourceGroup
  ]
}

module "Keyvault" {
  source = "../../modules/Keyvault"
  keyVaultVariables = var.keyVaultVariables
  depends_on = [
    # module.ResourceGroup
  ]
}

module "ComputeGallery" {
  source = "../../modules/ComputeGallery"
  acgVariables = var.acgVariables
    depends_on = [
     module.ResourceGroup
  ]
}
module "ComputeGalleryDefinition" {
  source = "../../modules/ComputeGalleryDefinition"
  imageDefinitionVariables = local.imageDefinitionVariables
    depends_on = [
     module.ComputeGallery,module.ResourceGroup
  ]
}
module "ComputeGalleryImageVersionData" {
  source = "../../modules/ComputeGalleryImageVersion"
 
  imageVersionDataVariables = local.imageVersionDataVariablesResolved
 
  depends_on = [
    module.ComputeGallery,
    # module.ResourceGroup
  ]
}
module "NetworkInterface" {
  source      = "../../modules/NetworkInterface"
  nicVariables = local.nicVariables
 
  depends_on = [
    module.Subnet,
    # module.ResourceGroup
  ]
}
module "SessionHost" {
  source       = "../../modules/SessionHost"
  sessionHosts = local.session_hosts_resolved
  hostpool_ids = local.hostpoolRegistrationVariables
  depends_on = [
    module.Hostpool,
    module.NetworkInterface,
    # module.ResourceGroup,
    module.ComputeGalleryImageVersionData
  ]
}
 module "SessionHostUnregister" {
  source        = "../../modules/SessionHostUnregister"
  hostpool_ids  = local.hostpoolRegistrationVariables
  session_hosts = local.unregister_session_hosts
  depends_on = [
    module.SessionHost,
    module.Hostpool,
    module.ResourceGroup
  ]

}
module "AzureMonitorAgent" {
  source = "../../modules/AzureMonitorAgent"
  vm_ids = { for k, v in module.SessionHost.sessionHost : k => v.id }
 
  depends_on = [
    module.SessionHost
  ]
}
 
module "DCE" {
  source       = "../../modules/DCE"
  dceVariables = local.dceVariablesResolved
  depends_on = [
    module.AzureMonitorAgent
  ]
}

module "DCR" {
  source       = "../../modules/DCR"
  dcrVariables = local.dcrVariablesResolved
  depends_on = [
    module.LogAnalyticsWorkspace,
    module.AzureMonitorAgent,
    module.ResourceGroup,module.DCE
    
  ]
}
module "DCEAssociation" {
  source          = "../../modules/DCEAssociation"
  dceAssociations = local.dceAssociationVariablesResolved
  depends_on = [
    module.DCE
  ]
}

module "DCRAssociation" {
  source          = "../../modules/DCRAssociation"
  dcrAssociations = local.dcrAssociationVariablesResolved
  depends_on = [
    module.DCR, module.DCEAssociation,module.DCE
  ]
}
module "ScalingPlan" {
  source = "../../modules/ScalingPlan"
  hostpool_ids         = { for k, v in module.Hostpool.hostpool : k => v.id }
  resource_group_ids   = { for k, v in module.ResourceGroup.rg : k => v.id }
  scalingPlanVariables = var.scalingPlanVariables
  depends_on = [
    module.Hostpool, module.ResourceGroup 
  ]
}
 
module "Alerts" {
  source         = "../../modules/Alerts"
  alertVariables = var.alertVariables
  workspace_ids  = { for k, v in module.LogAnalyticsWorkspace.LogAnalyticsWorkspace : k => v.id }
  action_group_ids_map = {for k, v in module.ActionGroup.action_groups : k => v.id }
 
  depends_on = [
    module.DCR,
    module.DCRAssociation,
    module.LogAnalyticsWorkspace,
    module.ResourceGroup
  ]
}
module "ActionGroup" {
  source = "../../modules/ActionGroup"
  actionGroupVariables = var.actionGroupVariables
  depends_on = [
    module.ResourceGroup]
  
}
module "ApplicationGroupAssignment" {
  source = "../../modules/ApplicationGroupAssignment"
 
  application_group_ids         = { for k, v in module.ApplicationGroup.applicationGroup : k => v.id }
  application_group_assignments = var.application_group_assignments
 
  depends_on = [
    module.ApplicationGroup
  ]
}
module "ServiceHealthAlert" {
  source = "../../modules/ServiceHealthAlert"
  serviceHealthAlertVariables = var.serviceHealthAlertVariables
  default_scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  action_group_ids_map = {for k, v in module.ActionGroup.action_groups : k => v.id }
  depends_on = [
    module.ActionGroup,
    module.ResourceGroup
  ]
}
# VM Lifecycle Automation 
module "ManagedIdentity" {
  source     = "../../modules/ManagedIdentity"
  mIdentity  = var.mIdentity
 
  depends_on = [
    module.ResourceGroup
  ]
}
module "ServiceBusNamespace" {
  source                       = "../../modules/ServiceBusNamespace"
  serviceBusNamespaceVariables = var.serviceBusNamespaceVariables
 
  depends_on = [
    module.ResourceGroup
  ]
}
module "ServiceBusQueue" {
  source = "../../modules/ServiceBusQueue"
 
  serviceBusQueueVariables = {
    for key, value in var.serviceBusQueueVariables : key => merge(value, {
      namespace_id = module.ServiceBusNamespace.serviceBusNamespaceIds[value.namespace_key]
    })
  }
 
  depends_on = [
    module.ServiceBusNamespace
  ]
}

module "StorageAccount" {
  source                  = "../../modules/StorageAccount"
  storageAccountVariables = var.storageAccountVariables
 
  depends_on = [
    module.ResourceGroup
  ]
}
 
module "AppServicePlan" {
  source                  = "../../modules/AppServicePlan"
  appServicePlanVariables = var.appServicePlanVariables
 
  depends_on = [
    module.ResourceGroup
  ]
}

module "ApplicationInsights" {
  source = "../../modules/ApplicationInsights"
 
  applicationInsightsVariables = {
    for key, value in var.applicationInsightsVariables : key => merge(value, {
      workspace_id = module.LogAnalyticsWorkspace.LogAnalyticsWorkspace[value.log_analytics_workspace_key].id
    })
  }
 
  depends_on = [
    module.ResourceGroup,
    module.LogAnalyticsWorkspace
  ]
}
/*
 
module "EventGridSystemTopic" {
  source = "../../modules/EventGridSystemTopic"
 
  eventGridSystemTopicVariables = {
    for key, value in var.eventGridSystemTopicVariables : key => merge(value, {
      source_resource_id = module.ResourceGroup.rgIds[value.source_resource_group_key]
      identity_type      = "UserAssigned"
      identity_ids       = [module.ManagedIdentity.managedIdentityIds[value.identity_key]]
    })
  }
 
  depends_on = [
    module.ResourceGroup,
    module.ManagedIdentity
  ]
}
 
module "EventGridSubscription" {
  source = "../../modules/EventGridSubscription"
 
  eventGridSubscriptionVariables = {
    for key, value in var.eventGridSubscriptionVariables : key => merge(value, {
      system_topic                  = module.EventGridSystemTopic.eventGridSystemTopicNames[value.system_topic_key]
      service_bus_queue_endpoint_id = module.ServiceBusQueue.serviceBusQueueIds[value.service_bus_queue_key]
      delivery_identity_type        = "UserAssigned"
      delivery_identity_id          = module.ManagedIdentity.managedIdentityIds[value.delivery_identity_key]
    })
  } 
  depends_on = [
    module.EventGridSystemTopic,
    module.ServiceBusNamespace,
    module.ServiceBusQueue,
    module.ManagedIdentity
  ]
}

module "WindowsFunctionApp" {
  source = "../../modules/WindowsFunctionApp"
 
  windowsFunctionAppVariables = {
    for key, value in var.windowsFunctionAppVariables : key => merge(value, {
      service_plan_id                      = module.AppServicePlan.appServicePlanIds[value.app_service_plan_key]
      storage_account_name                 = module.StorageAccount.storageAccountNames[value.storage_account_key]
      storage_account_access_key           = module.StorageAccount.storageAccountPrimaryAccessKeys[value.storage_account_key]
      identity_type                        = "UserAssigned"
      identity_ids                         = [module.ManagedIdentity.managedIdentityIds[value.managed_identity_key]]
      application_insights_connection_string = module.ApplicationInsights.applicationInsightsConnectionStrings[value.application_insights_resource_key]
      application_insights_key               = module.ApplicationInsights.applicationInsightsInstrumentationKeys[value.application_insights_resource_key]
 
      app_settings = merge(
        value.app_settings,
        {
          SERVICEBUS_QUEUE_NAME                         = module.ServiceBusQueue.serviceBusQueueNames[value.service_bus_queue_key]
          //ServiceBusConnection__fullyQualifiedNamespace = "${module.ServiceBusNamespace.serviceBusNamespaceNames[value.service_bus_namespace_key]}.${var.serviceBusEndpointSuffix}"
          ServiceBusConnection__credential              = "managedidentity"
          ServiceBusConnection__clientId                = module.ManagedIdentity.managedIdentityClientIds[value.managed_identity_key]
          MANAGED_IDENTITY_CLIENT_ID                    = module.ManagedIdentity.managedIdentityClientIds[value.managed_identity_key]
        }
      )
    })
  }
 
  depends_on = [
    module.AppServicePlan,
    module.StorageAccount,
    module.ManagedIdentity,
    module.ServiceBusNamespace,
    module.ServiceBusQueue,
    module.ApplicationInsights,
  ]
}*/
 