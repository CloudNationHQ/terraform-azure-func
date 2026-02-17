output "instance" {
  description = "Contains all function app config"
  value = (
    var.instance.type == "linux" ? azurerm_linux_function_app.this["func"] :
    var.instance.type == "windows" ? azurerm_windows_function_app.this["func"] :
    var.instance.type == "flex" ? azurerm_function_app_flex_consumption.this["func"] :
    null
  )
}

output "slots" {
  description = "contains all function app slot configurations"
  value       = var.instance.type == "linux" ? azurerm_linux_function_app_slot.slot : azurerm_windows_function_app_slot.slot
}
