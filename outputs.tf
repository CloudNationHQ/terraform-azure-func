output "instance" {
  description = "contains all function app config"
  value       = var.instance.type == "linux" ? try(azurerm_linux_function_app.func[var.instance.name], null) : try(azurerm_windows_function_app.func[var.instance.name], null)
}
