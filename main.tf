# linux function app
resource "azurerm_linux_function_app" "func" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = var.instance
  } : {}

  name                                           = var.instance.name
  resource_group_name                            = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location                                       = coalesce(lookup(var.instance, "location", null), var.location)
  service_plan_id                                = var.instance.service_plan_id
  storage_account_name                           = var.instance.storage_account_name
  storage_account_access_key                     = var.instance.storage_account_access_key
  https_only                                     = try(var.instance.https_only, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  enabled                                        = try(var.instance.enabled, true)
  builtin_logging_enabled                        = try(var.instance.builtin_logging_enabled, true)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, null)
  daily_memory_time_quota                        = try(var.instance.daily_memory_time_quota, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, false)
  functions_extension_version                    = try(var.instance.functions_extension_version, null)
  storage_key_vault_secret_id                    = try(var.instance.storage_key_vault_secret_id, null)
  content_share_force_disabled                   = try(var.instance.content_share_force_disabled, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  storage_uses_managed_identity                  = try(var.instance.storage_uses_managed_identity, null)
  vnet_image_pull_enabled                        = try(var.instance.vnet_image_pull_enabled, false)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)

  app_settings = try(
    var.instance.app_settings, null
  )

  tags = try(
    var.instance.tags, var.tags, null
  )

  dynamic "auth_settings_v2" {
    for_each = lookup(each.value, "auth_settings_v2", null) != null ? [lookup(each.value, "auth_settings_v2")] : []

    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      login {
        token_store_enabled               = try(auth_settings_v2.value.login.token_store_enabled, false)
        token_refresh_extension_time      = try(auth_settings_v2.value.login.token_refresh_extension_time, null)
        token_store_path                  = try(auth_settings_v2.value.login.token_store_path, null)
        token_store_sas_setting_name      = try(auth_settings_v2.value.login.token_store_sas_setting_name, null)
        preserve_url_fragments_for_logins = try(auth_settings_v2.value.login.preserve_url_fragments_for_logins, null)
        allowed_external_redirect_urls    = try(auth_settings_v2.value.login.allowed_external_redirect_urls, null)
        cookie_expiration_convention      = try(auth_settings_v2.value.login.cookie_expiration_convention, null)
        cookie_expiration_time            = try(auth_settings_v2.value.login.cookie_expiration_time, null)
        validate_nonce                    = try(auth_settings_v2.value.login.validate_nonce, null)
        nonce_expiration_time             = try(auth_settings_v2.value.login.nonce_expiration_time, null)
        logout_endpoint                   = try(auth_settings_v2.value.login.logout_endpoint, null)
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = try(apple_v2.value.login_scopes, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(auth_settings_v2.value.custom_oidc_v2, {})

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, "v15.0")
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

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
    ip_restriction_default_action                 = try(var.instance.site_config.ip_restriction_default_action, "Allow")
    scm_ip_restriction_default_action             = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value, "ip_restrictions", {}
      )

      content {
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.value.name, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)
        headers                   = try(ip_restriction.value.headers, [])
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value, "scm_ip_restrictions", {}
      )

      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        headers                   = try(scm_ip_restriction.value.headers, [])
        description               = try(scm_ip_restriction.value.description, null)
      }
    }

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
  lifecycle {
    ignore_changes = [
      auth_settings,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
  }
}

# linux function app slot
resource "azurerm_linux_function_app_slot" "slot" {
  for_each = {
    for key, value in try(var.instance.slots, {}) : key => value
    if var.instance.type == "linux"
  }

  name                                           = each.value.name
  function_app_id                                = var.instance.type == "linux" ? azurerm_linux_function_app.func[var.instance.name].id : azurerm_windows_function_app.func[var.instance.name].id
  storage_account_name                           = var.instance.storage_account_name
  storage_account_access_key                     = var.instance.storage_account_access_key
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  vnet_image_pull_enabled                        = try(var.instance.vnet_image_pull_enabled, false)
  content_share_force_disabled                   = try(var.instance.content_share_force_disabled, false)
  storage_uses_managed_identity                  = try(var.instance.storage_uses_managed_identity, null)
  enabled                                        = try(var.instance.enabled, true)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  storage_key_vault_secret_id                    = try(var.instance.storage_key_vault_secret_id, null)
  functions_extension_version                    = try(var.instance.functions_extension_version, "~4")
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, false)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  daily_memory_time_quota                        = try(var.instance.daily_memory_time_quota, 0)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Optional")
  builtin_logging_enabled                        = try(var.instance.builtin_logging_enabled, true)
  https_only                                     = try(var.instance.https_only, false)

  service_plan_id = lookup(
    each.value, "service_plan_id", null
  )

  tags = try(
    var.instance.tags, var.tags, null
  )

  app_settings = try(
    each.value.app_settings, null
  )

  dynamic "auth_settings_v2" {
    for_each = lookup(each.value, "auth_settings_v2", null) != null ? [lookup(each.value, "auth_settings_v2")] : []

    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      login {
        token_store_enabled               = try(auth_settings_v2.value.login.token_store_enabled, false)
        token_refresh_extension_time      = try(auth_settings_v2.value.login.token_refresh_extension_time, null)
        token_store_path                  = try(auth_settings_v2.value.login.token_store_path, null)
        token_store_sas_setting_name      = try(auth_settings_v2.value.login.token_store_sas_setting_name, null)
        preserve_url_fragments_for_logins = try(auth_settings_v2.value.login.preserve_url_fragments_for_logins, null)
        allowed_external_redirect_urls    = try(auth_settings_v2.value.login.allowed_external_redirect_urls, null)
        cookie_expiration_convention      = try(auth_settings_v2.value.login.cookie_expiration_convention, null)
        cookie_expiration_time            = try(auth_settings_v2.value.login.cookie_expiration_time, null)
        validate_nonce                    = try(auth_settings_v2.value.login.validate_nonce, null)
        nonce_expiration_time             = try(auth_settings_v2.value.login.nonce_expiration_time, null)
        logout_endpoint                   = try(auth_settings_v2.value.login.logout_endpoint, null)
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = try(apple_v2.value.login_scopes, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(auth_settings_v2.value.custom_oidc_v2, {})

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, "v15.0")
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name = lookup(
        connection_string.value, "name", connection_string.key
      )

      value = connection_string.value
      type  = connection_string.type
    }
  }

  dynamic "backup" {
    for_each = lookup(each.value, "backup", null) != null ? [lookup(each.value, "backup")] : []

    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = try(backup.value.enabled, true)

      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = try(backup.value.schedule.keep_at_least_one_backup, false)
        retention_period_days    = try(backup.value.schedule.retention_period_days, 30)
        start_time               = try(backup.value.schedule.start_time, null)
        last_execution_time      = try(backup.value.schedule.last_execution_time, null)
      }
    }
  }

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
    scm_ip_restriction_default_action             = try(each.value.site_config.scm_ip_restriction_default_action, "Allow")
    ip_restriction_default_action                 = try(each.value.site_config.ip_restriction_default_action, "Allow")

    dynamic "ip_restriction" {
      for_each = try(
        var.instance.site_config.ip_restrictions, {}
      )

      content {
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.value.name, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)
        headers                   = try(ip_restriction.value.headers, [])
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = try(var.instance.site_config.scm_ip_restriction, {})

      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        headers                   = try(scm_ip_restriction.value.headers, [])
        description               = try(scm_ip_restriction.value.description, null)
      }
    }

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
  lifecycle {
    ignore_changes = [
      auth_settings,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
  }
}

# windows function app
resource "azurerm_windows_function_app" "func" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = var.instance
  } : {}

  name                                           = var.instance.name
  resource_group_name                            = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location                                       = coalesce(lookup(var.instance, "location", null), var.location)
  service_plan_id                                = var.instance.service_plan_id
  storage_account_name                           = var.instance.storage_account_name
  storage_account_access_key                     = var.instance.storage_account_access_key
  https_only                                     = try(var.instance.https_only, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  enabled                                        = try(var.instance.enabled, true)
  builtin_logging_enabled                        = try(var.instance.builtin_logging_enabled, true)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, null)
  daily_memory_time_quota                        = try(var.instance.daily_memory_time_quota, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, false)
  functions_extension_version                    = try(var.instance.functions_extension_version, null)
  storage_key_vault_secret_id                    = try(var.instance.storage_key_vault_secret_id, null)
  content_share_force_disabled                   = try(var.instance.content_share_force_disabled, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  storage_uses_managed_identity                  = try(var.instance.storage_uses_managed_identity, null)
  vnet_image_pull_enabled                        = try(var.instance.vnet_image_pull_enabled, false)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)

  app_settings = try(
    var.instance.app_settings, null
  )

  tags = try(
    var.instance.tags, var.tags, null
  )

  dynamic "auth_settings_v2" {
    for_each = lookup(each.value, "auth_settings_v2", null) != null ? [lookup(each.value, "auth_settings_v2")] : []

    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      login {
        token_store_enabled               = try(auth_settings_v2.value.login.token_store_enabled, false)
        token_refresh_extension_time      = try(auth_settings_v2.value.login.token_refresh_extension_time, null)
        token_store_path                  = try(auth_settings_v2.value.login.token_store_path, null)
        token_store_sas_setting_name      = try(auth_settings_v2.value.login.token_store_sas_setting_name, null)
        preserve_url_fragments_for_logins = try(auth_settings_v2.value.login.preserve_url_fragments_for_logins, null)
        allowed_external_redirect_urls    = try(auth_settings_v2.value.login.allowed_external_redirect_urls, null)
        cookie_expiration_convention      = try(auth_settings_v2.value.login.cookie_expiration_convention, null)
        cookie_expiration_time            = try(auth_settings_v2.value.login.cookie_expiration_time, null)
        validate_nonce                    = try(auth_settings_v2.value.login.validate_nonce, null)
        nonce_expiration_time             = try(auth_settings_v2.value.login.nonce_expiration_time, null)
        logout_endpoint                   = try(auth_settings_v2.value.login.logout_endpoint, null)
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = try(apple_v2.value.login_scopes, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(auth_settings_v2.value.custom_oidc_v2, {})

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, "v15.0")
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

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
    ip_restriction_default_action          = try(var.instance.site_config.ip_restriction_default_action, "Allow")
    scm_ip_restriction_default_action      = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value, "ip_restrictions", {}
      )

      content {
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.value.name, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)
        headers                   = try(ip_restriction.value.headers, [])
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value, "scm_ip_restrictions", {}
      )

      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        headers                   = try(scm_ip_restriction.value.headers, [])
        description               = try(scm_ip_restriction.value.description, null)
      }
    }

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
  lifecycle {
    ignore_changes = [
      auth_settings,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
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

  storage_account_name                           = var.instance.storage_account_name
  storage_account_access_key                     = var.instance.storage_account_access_key
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  storage_uses_managed_identity                  = try(var.instance.storage_uses_managed_identity, null)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  content_share_force_disabled                   = try(var.instance.content_share_force_disabled, false)
  storage_key_vault_secret_id                    = try(var.instance.storage_key_vault_secret_id, null)
  functions_extension_version                    = try(var.instance.functions_extension_version, "~4")
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, false)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  vnet_image_pull_enabled                        = try(var.instance.vnet_image_pull_enabled, false)
  daily_memory_time_quota                        = try(var.instance.daily_memory_time_quota, 0)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Optional")
  builtin_logging_enabled                        = try(var.instance.builtin_logging_enabled, true)
  https_only                                     = try(var.instance.https_only, false)
  enabled                                        = try(var.instance.enabled, true)

  service_plan_id = lookup(
    each.value, "service_plan_id", null
  )

  app_settings = try(
    each.value.app_settings, null
  )

  tags = try(
    var.instance.tags, var.tags, null
  )

  dynamic "auth_settings_v2" {
    for_each = lookup(each.value, "auth_settings_v2", null) != null ? [lookup(each.value, "auth_settings_v2")] : []

    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      login {
        token_store_enabled               = try(auth_settings_v2.value.login.token_store_enabled, false)
        token_refresh_extension_time      = try(auth_settings_v2.value.login.token_refresh_extension_time, null)
        token_store_path                  = try(auth_settings_v2.value.login.token_store_path, null)
        token_store_sas_setting_name      = try(auth_settings_v2.value.login.token_store_sas_setting_name, null)
        preserve_url_fragments_for_logins = try(auth_settings_v2.value.login.preserve_url_fragments_for_logins, null)
        allowed_external_redirect_urls    = try(auth_settings_v2.value.login.allowed_external_redirect_urls, null)
        cookie_expiration_convention      = try(auth_settings_v2.value.login.cookie_expiration_convention, null)
        cookie_expiration_time            = try(auth_settings_v2.value.login.cookie_expiration_time, null)
        validate_nonce                    = try(auth_settings_v2.value.login.validate_nonce, null)
        nonce_expiration_time             = try(auth_settings_v2.value.login.nonce_expiration_time, null)
        logout_endpoint                   = try(auth_settings_v2.value.login.logout_endpoint, null)
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = try(apple_v2.value.login_scopes, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(auth_settings_v2.value.custom_oidc_v2, {})

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, "v15.0")
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name = lookup(
        connection_string.value, "name", connection_string.key
      )

      value = connection_string.value
      type  = connection_string.type
    }
  }

  dynamic "backup" {
    for_each = lookup(each.value, "backup", null) != null ? [lookup(each.value, "backup")] : []

    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = try(backup.value.enabled, true)

      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = try(backup.value.schedule.keep_at_least_one_backup, false)
        retention_period_days    = try(backup.value.schedule.retention_period_days, 30)
        start_time               = try(backup.value.schedule.start_time, null)
        last_execution_time      = try(backup.value.schedule.last_execution_time, null)
      }
    }
  }

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
    ip_restriction_default_action          = try(var.instance.site_config.ip_restriction_default_action, "Allow")
    scm_ip_restriction_default_action      = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")

    dynamic "ip_restriction" {
      for_each = try(
        var.instance.site_config.ip_restrictions, {}
      )

      content {
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.value.name, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)
        headers                   = try(ip_restriction.value.headers, [])
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = try(var.instance.site_config.scm_ip_restriction, {})

      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        headers                   = try(scm_ip_restriction.value.headers, [])
        description               = try(scm_ip_restriction.value.description, null)
      }
    }

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
  lifecycle {
    ignore_changes = [
      auth_settings,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
  }
}
