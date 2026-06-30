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
output "alerts" {
  description = "IDs of alerts"
  value = { for k, alert in module.Alerts.alerts : k => alert.id } 
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


 