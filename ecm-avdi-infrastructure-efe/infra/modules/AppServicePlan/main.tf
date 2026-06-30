resource "azurerm_service_plan" "appServicePlan" {
  for_each = var.appServicePlanVariables
 
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  os_type                      = try(each.value.os_type, "Windows")
  sku_name                     = try(each.value.sku_name, "Y1")
  worker_count                 = try(each.value.worker_count, null)
  per_site_scaling_enabled     = try(each.value.per_site_scaling_enabled, null)
  zone_balancing_enabled       = try(each.value.zone_balancing_enabled, null)
  maximum_elastic_worker_count = try(each.value.maximum_elastic_worker_count, null)
 
  tags = try(each.value.tags, {})
 
  lifecycle {
    prevent_destroy = true
  }
}