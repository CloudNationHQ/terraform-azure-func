output "plans" {
  description = "contains the service plans"
  value = {
    for k, plan in azurerm_service_plan.plans : k => plan
  }
}
