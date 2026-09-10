output "function_app" {
  description = "Contains all function app config"
  value = one(values(merge(
    azurerm_linux_function_app.this,
    azurerm_windows_function_app.this,
    azurerm_function_app_flex_consumption.this
  )))
}

output "slots" {
  description = "contains all function app slot configurations"
  value = merge(
    azurerm_linux_function_app_slot.this, azurerm_windows_function_app_slot.this
  )
}

output "functions" {
  description = "contains all function app function configurations"
  value       = azurerm_function_app_function.this
}
