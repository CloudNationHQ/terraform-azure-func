# service plans
resource "azurerm_service_plan" "plans" {
  for_each = var.plans

  name                         = each.value.name
  resource_group_name          = var.resource_group
  location                     = var.location
  os_type                      = each.value.os_type
  sku_name                     = each.value.sku_name
  worker_count                 = try(each.value.worker_count, null)
  zone_balancing_enabled       = try(each.value.zone_balancing_enabled, false)
  per_site_scaling_enabled     = try(each.value.per_site_scaling_enabled, false)
  app_service_environment_id   = try(each.value.app_service_environment_id, null)
  maximum_elastic_worker_count = try(each.value.maximum_elastic_worker_count, null)
  tags                         = try(each.value.tags, var.tags, null)
}
