output "instance" {
  description = "Contains all function app config"
  value = (
    var.instance.type == "linux" ? azurerm_linux_function_app.func[var.instance.name] :
    var.instance.type == "windows" ? azurerm_windows_function_app.func[var.instance.name] :
    var.instance.type == "flex" ? azurerm_function_app_flex_consumption.func[var.instance.name] :
    null
  )
}
