terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}
# This module removes Session Hosts from Host Pools in Azure Virtual Desktop when the Session Host resource is destroyed. It uses the azapi provider to call the Azure API directly to perform the deletion of the Session Host from the Host Pool.
resource "azapi_resource_action" "remove_session_host_from_hostpool" {
  for_each = var.session_hosts
  type        = "Microsoft.DesktopVirtualization/hostPools/sessionHosts@2024-04-03"
  resource_id = "${var.hostpool_ids[each.value.hostpool_key]}/sessionHosts/${each.value.registration_name}"
  method      = "DELETE"
  when        = "destroy"
  query_parameters = {
    force = ["true"]
  }

}



 