output "resource_group_ids" {
  description = "Resource Group IDs by key"
  value       = { for k, rg in module.ResourceGroup.rg : k => rg.id }
}
output "subnet_id" {
  description = "ID of subnet"
  value = { for k, snet in module.Subnet.snet : k => snet.id }
}

output "nsg_id" {
  description = "IDs of created NSGs"
  value = { for k, nsg in module.NetworkSecurityGroup.nsg : k => nsg.id }
}
output "nsgAssociation_id" {
  description = "IDs of NSG-Subnet associations"
  value = { for k, assoc in module.nsgSubnetAssociation.nsgSubnetAssociation : k => assoc.id }
}
output "hostpool_id" {
  description = "IDs of created Host Pools"
  value = { for k, hostpool in module.Hostpool.hostpool : k => hostpool.id }
}

output "application_group_id" {
  description = "IDs of created Application Groups"
  value       = { for k, ag in module.ApplicationGroup.applicationGroup : k => ag.id }
}
 
output "workspace_application_group_association_id" {
  description = "IDs of workspace to application group associations"
  value       = { for k, assoc in module.WorkspaceApplicationGroupAssociation.workspaceApplicationGroupAssociation : k => assoc.id }
}
output "law" {
  description = "IDs of log analytics woekspace"
  value = { for k, law in module.LogAnalyticsWorkspace.LogAnalyticsWorkspace : k => law.id }
}

output "session_host_vm_id" {
  description = "IDs of created session host VMs"
  value       = { for k, vm in module.SessionHost.sessionHost : k => vm.id }
}
 output "dcr_id" {
  description = "ids of created dcr"
  value = { for k, dcr in module.DCR.dcr : k => dcr.id }
}

output "dcrAssociation_id" {
  description = "IDs of DCR associations to session host VMs"
  value = { for k, assoc in module.DCRAssociation.dcr_association : k => assoc.id }
}
output "dce_id" {
  description = "Ids of DCE"
  value = { for k, dce in module.DCE.dce : k => dce.id }
}
output "dceAssociation_id" {
  description = "IDs of DCE associations to session host VMs"
  value = { for k, assoc in module.DCEAssociation.dce_association : k => assoc.id }
}
output "scalingplan_id" {
  description = "IDs of scaling plans"
  value = { for k, sp in module.ScalingPlan.scalingPlan : k => sp.id }
  
}
output "managed_identity_ids" {
  description = "User assigned managed identity IDs by key."
  value       = { for k, mi in module.ManagedIdentity.mIdentity : k => mi.id }
}
output "service_bus_namespace_ids" {
  description = "Service Bus namespace IDs by key."
  value       = { for k, ns in module.ServiceBusNamespace.serviceBusNamespace : k => ns.id }
} 
output "service_bus_queue_ids" {
  description = "Service Bus queue IDs by key."
  value       = { for k, queue in module.ServiceBusQueue.serviceBusQueue : k => queue.id }
}
output "application_insights_ids" {
  description = "Application Insights IDs by key."
  value       = { for k, ai in module.ApplicationInsights.applicationInsights : k => ai.id }
}
output "storage_account_ids" {
  description = "Storage Account IDs by key."
  value       = { for k, sa in module.StorageAccount.storageAccount : k => sa.id }
  sensitive   = true
}
/*
output "event_grid_system_topic_ids" {
  description = "Event Grid system topic IDs by key."
  value       = { for k, st in module.EventGridSystemTopic.eventGridSystemTopic : k => st.id }
}
 
output "event_grid_subscription_ids" {
  description = "Event Grid subscription IDs by key."
  value       = { for k, sub in module.EventGridSubscription.eventGridSubscription : k => sub.id }
}

output "function_app_id" {
  description = "IDs of created Function Apps"
  value       = { for k, fa in module.WindowsFunctionApp.windowsFunctionApp : k => fa.id }
  
}
*/