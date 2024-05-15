data "azurerm_subscription" "current" {}

# linux function app
resource "azurerm_linux_function_app" "func" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = var.instance
  } : {}

  name                          = var.instance.name
  resource_group_name           = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location                      = coalesce(lookup(var.instance, "location", null), var.location)
  service_plan_id               = var.instance.service_plan_id
  storage_account_name          = var.instance.storage_account_name
  storage_account_access_key    = var.instance.storage_account_access_key
  https_only                    = try(var.instance.https_only, true)
  zip_deploy_file               = try(var.instance.zip_deploy_file, null)
  enabled                       = try(var.instance.enabled, true)
  builtin_logging_enabled       = try(var.instance.builtin_logging_enabled, true)
  client_certificate_mode       = try(var.instance.client_certificate_mode, null)
  daily_memory_time_quota       = try(var.instance.daily_memory_time_quota, null)
  virtual_network_subnet_id     = try(var.instance.virtual_network_subnet_id, null)
  client_certificate_enabled    = try(var.instance.client_certificate_enabled, false)
  functions_extension_version   = try(var.instance.functions_extension_version, null)
  storage_key_vault_secret_id   = try(var.instance.storage_key_vault_secret_id, null)
  content_share_force_disabled  = try(var.instance.content_share_force_disabled, false)
  public_network_access_enabled = try(var.instance.public_network_access_enabled, true)
  storage_uses_managed_identity = try(var.instance.storage_uses_managed_identity, null)
  app_settings                  = try(var.instance.app_settings, null)
  tags                          = try(var.instance.tags, var.tags, null)

  site_config {
    always_on                                     = try(var.instance.site_config.always_on, false)
    ftps_state                                    = try(var.instance.site_config.ftps_state, "AllAllowed")
    worker_count                                  = try(var.instance.site_config.worker_count, null)
    http2_enabled                                 = try(var.instance.site_config.http2_enabled, true)
    app_scale_limit                               = try(var.instance.site_config.app_scale_limit, null)
    app_command_line                              = try(var.instance.site_config.app_command_line, null)
    remote_debugging_version                      = try(var.instance.site_config.remote_debugging_version, null)
    pre_warmed_instance_count                     = try(var.instance.site_config.pre_warmed_instance_count, null)
    runtime_scale_monitoring_enabled              = try(var.instance.site_config.runtime_scale_monitoring_enabled, false)
    scm_use_main_ip_restriction                   = try(var.instance.site_config.scm_use_main_ip_restriction, false)
    health_check_eviction_time_in_min             = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    application_insights_connection_string        = try(var.instance.site_config.application_insights_connection_string, null)
    container_registry_use_managed_identity       = try(var.instance.site_config.container_registry_use_managed_identity, false)
    container_registry_managed_identity_client_id = try(var.instance.site_config.container_registry_managed_identity_client_id, null)
    minimum_tls_version                           = try(var.instance.site_config.minimum_tls_version, "1.2")
    api_management_api_id                         = try(var.instance.site_config.api_management_api_id, null)
    managed_pipeline_mode                         = try(var.instance.site_config.managed_pipeline_mode, null)
    vnet_route_all_enabled                        = try(var.instance.site_config.vnet_route_all_enabled, false)
    scm_minimum_tls_version                       = try(var.instance.site_config.scm_minimum_tls_version, "1.2")
    application_insights_key                      = try(var.instance.site_config.application_insights_key, null)
    elastic_instance_minimum                      = try(var.instance.site_config.elastic_instance_minimum, null)
    remote_debugging_enabled                      = try(var.instance.site_config.remote_debugging_enabled, false)
    default_documents                             = try(var.instance.site_config.default_documents, null)
    health_check_path                             = try(var.instance.site_config.health_check_path, null)
    use_32_bit_worker                             = try(var.instance.site_config.use_32_bit_worker, false)
    api_definition_url                            = try(var.instance.site_config.api_definition_url, null)
    websockets_enabled                            = try(var.instance.site_config.websockets_enabled, true)
    load_balancing_mode                           = try(var.instance.site_config.load_balancing_mode, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        dotnet_version              = try(application_stack.value.dotnet_version, null)
        use_dotnet_isolated_runtime = try(application_stack.value.use_dotnet_isolated_runtime, null)
        java_version                = try(application_stack.value.java_version, null)
        node_version                = try(application_stack.value.node_version, null)
        python_version              = try(application_stack.value.python_version, null)
        powershell_core_version     = try(application_stack.value.powershell_core_version, null)
        use_custom_runtime          = try(application_stack.value.use_custom_runtime, null)

        dynamic "docker" {
          for_each = lookup(application_stack.value, "docker", null) != null ? [lookup(application_stack.value, "docker")] : []
          content {
            image_name        = docker.value.image_name
            image_tag         = docker.value.image_tag
            registry_url      = docker.value.registry_url
            registry_username = docker.value.registry_username
            registry_password = docker.value.registry_password
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []

      content {
        allowed_origins     = try(cors.value.allowed_origins, [])
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "app_service_logs" {
      for_each = lookup(each.value.site_config, "app_service_logs", null) != null ? [lookup(each.value.site_config, "app_service_logs")] : []

      content {
        disk_quota_mb         = try(app_service_logs.value.disk_quota_mb, null)
        retention_period_days = try(app_service_logs.value.retention_period_days, null)
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.instance.sticky_settings, null) != null ? [1] : []

    content {
      app_setting_names       = try(var.instance.sticky_settings.app_setting_names, [])
      connection_string_names = try(var.instance.sticky_settings.connection_string_names, [])
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? [1] : []

    content {
      name                = var.instance.backup.name
      enabled             = try(var.instance.backup.enabled, true)
      storage_account_url = var.instance.backup.storage_account_url

      schedule {
        frequency_unit           = var.instance.backup.schedule.frequency_unit
        frequency_interval       = var.instance.backup.schedule.frequency_interval
        retention_period_days    = try(var.instance.backup.schedule.retention_period_days, null)
        start_time               = try(var.instance.backup.schedule.start_time, null)
        keep_at_least_one_backup = try(var.instance.backup.schedule.keep_at_least_one_backup, false)
      }
    }
  }

  dynamic "connection_string" {
    for_each = {
      for k, v in try(var.instance.connection_string, {}) : k => v
    }

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
}

# linux function app slot
resource "azurerm_linux_function_app_slot" "slot" {
  for_each = {
    for key, value in try(var.instance.slots, {}) : key => value
    if var.instance.type == "linux"
  }

  name            = each.value.name
  function_app_id = var.instance.type == "linux" ? azurerm_linux_function_app.func[var.instance.name].id : azurerm_windows_function_app.func[var.instance.name].id

  storage_account_name       = var.instance.storage_account_name
  storage_account_access_key = var.instance.storage_account_access_key
  app_settings               = try(each.value.app_settings, null)

  site_config {
    always_on                                     = try(each.value.site_config.always_on, false)
    ftps_state                                    = try(each.value.site_config.ftps_state, "Disabled")
    worker_count                                  = try(each.value.site_config.worker_count, null)
    http2_enabled                                 = try(each.value.site_config.http2_enabled, false)
    app_scale_limit                               = try(each.value.site_config.app_scale_limit, null)
    app_command_line                              = try(each.value.site_config.app_command_line, null)
    remote_debugging_version                      = try(each.value.site_config.remote_debugging_version, null)
    pre_warmed_instance_count                     = try(each.value.site_config.pre_warmed_instance_count, null)
    runtime_scale_monitoring_enabled              = try(each.value.site_config.runtime_scale_monitoring_enabled, false)
    scm_use_main_ip_restriction                   = try(each.value.site_config.scm_use_main_ip_restriction, false)
    health_check_eviction_time_in_min             = try(each.value.site_config.health_check_eviction_time_in_min, null)
    application_insights_connection_string        = try(each.value.site_config.application_insights_connection_string, null)
    container_registry_use_managed_identity       = try(each.value.site_config.container_registry_use_managed_identity, false)
    container_registry_managed_identity_client_id = try(each.value.site_config.container_registry_managed_identity_client_id, null)
    minimum_tls_version                           = try(each.value.site_config.minimum_tls_version, "1.2")
    api_management_api_id                         = try(each.value.site_config.api_management_api_id, null)
    managed_pipeline_mode                         = try(each.value.site_config.managed_pipeline_mode, null)
    vnet_route_all_enabled                        = try(each.value.site_config.vnet_route_all_enabled, false)
    scm_minimum_tls_version                       = try(each.value.site_config.scm_minimum_tls_version, "1.2")
    application_insights_key                      = try(each.value.site_config.application_insights_key, null)
    elastic_instance_minimum                      = try(each.value.site_config.elastic_instance_minimum, null)
    remote_debugging_enabled                      = try(each.value.site_config.remote_debugging_enabled, false)
    default_documents                             = try(each.value.site_config.default_documents, null)
    health_check_path                             = try(each.value.site_config.health_check_path, null)
    use_32_bit_worker                             = try(each.value.site_config.use_32_bit_worker, false)
    api_definition_url                            = try(each.value.site_config.api_definition_url, null)
    auto_swap_slot_name                           = try(each.value.site_config.auto_swap_slot_name, null)
    websockets_enabled                            = try(each.value.site_config.websockets_enabled, false)
    load_balancing_mode                           = try(each.value.site_config.load_balancing_mode, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        dotnet_version              = try(application_stack.value.dotnet_version, null)
        use_dotnet_isolated_runtime = try(application_stack.value.use_dotnet_isolated_runtime, null)
        java_version                = try(application_stack.value.java_version, null)
        node_version                = try(application_stack.value.node_version, null)
        python_version              = try(application_stack.value.python_version, null)
        powershell_core_version     = try(application_stack.value.powershell_core_version, null)
        use_custom_runtime          = try(application_stack.value.use_custom_runtime, null)

        dynamic "docker" {
          for_each = lookup(application_stack.value, "docker", null) != null ? [lookup(application_stack.value, "docker")] : []
          content {
            image_name        = docker.value.image_name
            image_tag         = docker.value.image_tag
            registry_url      = docker.value.registry_url
            registry_username = docker.value.registry_username
            registry_password = docker.value.registry_password
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []

      content {
        allowed_origins     = try(cors.value.allowed_origins, [])
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "app_service_logs" {
      for_each = lookup(each.value.site_config, "app_service_logs", null) != null ? [lookup(each.value.site_config, "app_service_logs")] : []

      content {
        disk_quota_mb         = try(app_service_logs.value.disk_quota_mb, null)
        retention_period_days = try(app_service_logs.value.retention_period_days, null)
      }
    }
  }
}

# windows function app
resource "azurerm_windows_function_app" "func" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = var.instance
  } : {}

  name                          = var.instance.name
  resource_group_name           = coalesce(lookup(var.instance, "resourcegroup", null), var.resourcegroup)
  location                      = coalesce(lookup(var.instance, "location", null), var.location)
  service_plan_id               = var.instance.service_plan_id
  storage_account_name          = var.instance.storage_account_name
  storage_account_access_key    = var.instance.storage_account_access_key
  https_only                    = try(var.instance.https_only, true)
  zip_deploy_file               = try(var.instance.zip_deploy_file, null)
  enabled                       = try(var.instance.enabled, true)
  builtin_logging_enabled       = try(var.instance.builtin_logging_enabled, true)
  client_certificate_mode       = try(var.instance.client_certificate_mode, null)
  daily_memory_time_quota       = try(var.instance.daily_memory_time_quota, null)
  virtual_network_subnet_id     = try(var.instance.virtual_network_subnet_id, null)
  client_certificate_enabled    = try(var.instance.client_certificate_enabled, false)
  functions_extension_version   = try(var.instance.functions_extension_version, null)
  storage_key_vault_secret_id   = try(var.instance.storage_key_vault_secret_id, null)
  content_share_force_disabled  = try(var.instance.content_share_force_disabled, false)
  public_network_access_enabled = try(var.instance.public_network_access_enabled, true)
  storage_uses_managed_identity = try(var.instance.storage_uses_managed_identity, null)
  app_settings                  = try(var.instance.app_settings, null)
  tags                          = try(var.instance.tags, var.tags, null)

  site_config {
    always_on                              = try(var.instance.site_config.always_on, false)
    ftps_state                             = try(var.instance.site_config.ftps_state, "AllAllowed")
    worker_count                           = try(var.instance.site_config.worker_count, null)
    http2_enabled                          = try(var.instance.site_config.http2_enabled, true)
    app_scale_limit                        = try(var.instance.site_config.app_scale_limit, null)
    app_command_line                       = try(var.instance.site_config.app_command_line, null)
    remote_debugging_version               = try(var.instance.site_config.remote_debugging_version, null)
    pre_warmed_instance_count              = try(var.instance.site_config.pre_warmed_instance_count, null)
    runtime_scale_monitoring_enabled       = try(var.instance.site_config.runtime_scale_monitoring_enabled, false)
    scm_use_main_ip_restriction            = try(var.instance.site_config.scm_use_main_ip_restriction, false)
    health_check_eviction_time_in_min      = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    application_insights_connection_string = try(var.instance.site_config.application_insights_connection_string, null)
    minimum_tls_version                    = try(var.instance.site_config.minimum_tls_version, "1.2")
    api_management_api_id                  = try(var.instance.site_config.api_management_api_id, null)
    managed_pipeline_mode                  = try(var.instance.site_config.managed_pipeline_mode, null)
    vnet_route_all_enabled                 = try(var.instance.site_config.vnet_route_all_enabled, false)
    scm_minimum_tls_version                = try(var.instance.site_config.scm_minimum_tls_version, "1.2")
    application_insights_key               = try(var.instance.site_config.application_insights_key, null)
    elastic_instance_minimum               = try(var.instance.site_config.elastic_instance_minimum, null)
    remote_debugging_enabled               = try(var.instance.site_config.remote_debugging_enabled, false)
    default_documents                      = try(var.instance.site_config.default_documents, null)
    health_check_path                      = try(var.instance.site_config.health_check_path, null)
    use_32_bit_worker                      = try(var.instance.site_config.use_32_bit_worker, false)
    api_definition_url                     = try(var.instance.site_config.api_definition_url, null)
    websockets_enabled                     = try(var.instance.site_config.websockets_enabled, false)
    load_balancing_mode                    = try(var.instance.site_config.load_balancing_mode, null)

    dynamic "application_stack" {
      for_each = try(var.instance.site_config.application_stack, null) != null ? [1] : []

      content {
        dotnet_version              = try(var.instance.site_config.application_stack.dotnet_version, null)
        use_dotnet_isolated_runtime = try(var.instance.site_config.application_stack.use_dotnet_isolated_runtime, null)
        java_version                = try(var.instance.site_config.application_stack.java_version, null)
        node_version                = try(var.instance.site_config.application_stack.node_version, null)
        powershell_core_version     = try(var.instance.site_config.application_stack.powershell_core_version, null)
        use_custom_runtime          = try(var.instance.site_config.application_stack.use_custom_runtime, null)
      }
    }

    dynamic "cors" {
      for_each = try(var.instance.site_config.cors, null) != null ? [1] : []

      content {
        allowed_origins     = try(var.instance.site_config.cors.allowed_origins, [])
        support_credentials = try(var.instance.site_config.cors.support_credentials, false)
      }
    }

    dynamic "app_service_logs" {
      for_each = try(var.instance.site_config.app_service_logs, null) != null ? [1] : []

      content {
        disk_quota_mb         = try(var.instance.site_config.app_service_logs.disk_quota_mb, null)
        retention_period_days = try(var.instance.site_config.app_service_logs.retention_period_days, null)
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.instance.sticky_settings, null) != null ? [1] : []

    content {
      app_setting_names       = try(var.instance.sticky_settings.app_setting_names, [])
      connection_string_names = try(var.instance.sticky_settings.connection_string_names, [])
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? [1] : []

    content {
      name                = var.instance.backup.name
      enabled             = try(var.instance.backup.enabled, true)
      storage_account_url = var.instance.backup.storage_account_url

      schedule {
        frequency_unit           = var.instance.backup.schedule.frequency_unit
        frequency_interval       = var.instance.backup.schedule.frequency_interval
        retention_period_days    = try(var.instance.backup.schedule.retention_period_days, null)
        start_time               = try(var.instance.backup.schedule.start_time, null)
        keep_at_least_one_backup = try(var.instance.backup.schedule.keep_at_least_one_backup, false)
      }
    }
  }

  dynamic "connection_string" {
    for_each = {
      for k, v in try(var.instance.connection_string, {}) : k => v
    }

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
}

# windows function app slot
resource "azurerm_windows_function_app_slot" "slot" {
  for_each = {
    for key, value in try(var.instance.slots, {}) : key => value
    if var.instance.type == "windows"
  }

  name            = each.value.name
  function_app_id = var.instance.type == "linux" ? azurerm_linux_function_app.func[var.instance.name].id : azurerm_windows_function_app.func[var.instance.name].id

  storage_account_name       = var.instance.storage_account_name
  storage_account_access_key = var.instance.storage_account_access_key
  app_settings               = try(each.value.app_settings, null)

  site_config {
    always_on                              = try(var.instance.site_config.always_on, false)
    ftps_state                             = try(var.instance.site_config.ftps_state, "Disabled")
    worker_count                           = try(var.instance.site_config.worker_count, null)
    http2_enabled                          = try(var.instance.site_config.http2_enabled, false)
    app_scale_limit                        = try(var.instance.site_config.app_scale_limit, null)
    app_command_line                       = try(var.instance.site_config.app_command_line, null)
    remote_debugging_version               = try(var.instance.site_config.remote_debugging_version, null)
    pre_warmed_instance_count              = try(var.instance.site_config.pre_warmed_instance_count, null)
    runtime_scale_monitoring_enabled       = try(var.instance.site_config.runtime_scale_monitoring_enabled, false)
    scm_use_main_ip_restriction            = try(var.instance.site_config.scm_use_main_ip_restriction, false)
    health_check_eviction_time_in_min      = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    application_insights_connection_string = try(var.instance.site_config.application_insights_connection_string, null)
    minimum_tls_version                    = try(var.instance.site_config.minimum_tls_version, "1.2")
    api_management_api_id                  = try(var.instance.site_config.api_management_api_id, null)
    managed_pipeline_mode                  = try(var.instance.site_config.managed_pipeline_mode, null)
    vnet_route_all_enabled                 = try(var.instance.site_config.vnet_route_all_enabled, false)
    scm_minimum_tls_version                = try(var.instance.site_config.scm_minimum_tls_version, "1.2")
    application_insights_key               = try(var.instance.site_config.application_insights_key, null)
    elastic_instance_minimum               = try(var.instance.site_config.elastic_instance_minimum, null)
    remote_debugging_enabled               = try(var.instance.site_config.remote_debugging_enabled, false)
    default_documents                      = try(var.instance.site_config.default_documents, null)
    health_check_path                      = try(var.instance.site_config.health_check_path, null)
    use_32_bit_worker                      = try(var.instance.site_config.use_32_bit_worker, false)
    api_definition_url                     = try(var.instance.site_config.api_definition_url, null)
    auto_swap_slot_name                    = try(var.instance.site_config.auto_swap_slot_name, null)
    websockets_enabled                     = try(var.instance.site_config.websockets_enabled, false)
    load_balancing_mode                    = try(var.instance.site_config.load_balancing_mode, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        dotnet_version              = try(application_stack.value.dotnet_version, null)
        use_dotnet_isolated_runtime = try(application_stack.value.use_dotnet_isolated_runtime, null)
        java_version                = try(application_stack.value.java_version, null)
        node_version                = try(application_stack.value.node_version, null)
        powershell_core_version     = try(application_stack.value.powershell_core_version, null)
        use_custom_runtime          = try(application_stack.value.use_custom_runtime, null)
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []

      content {
        allowed_origins     = try(cors.value.allowed_origins, [])
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "app_service_logs" {
      for_each = lookup(each.value.site_config, "app_service_logs", null) != null ? [lookup(each.value.site_config, "app_service_logs")] : []

      content {
        disk_quota_mb         = try(app_service_logs.value.disk_quota_mb, null)
        retention_period_days = try(app_service_logs.value.retention_period_days, null)
      }
    }
  }
}
