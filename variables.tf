variable "instance" {
  description = "Contains all function app configuration"
  type = object({
    name                = string
    type                = string
    resource_group_name = optional(string)
    location            = optional(string)
    service_plan_id     = string

    # shared settings
    https_only   = optional(bool, true)
    enabled      = optional(bool, true)
    app_settings = optional(map(string))
    tags         = optional(map(string))

    # classic windows/linux settings
    storage_account_name                           = optional(string)
    storage_account_access_key                     = optional(string)
    zip_deploy_file                                = optional(string)
    builtin_logging_enabled                        = optional(bool, true)
    client_certificate_mode                        = optional(string)
    daily_memory_time_quota                        = optional(number)
    virtual_network_subnet_id                      = optional(string)
    client_certificate_enabled                     = optional(bool, false)
    functions_extension_version                    = optional(string)
    storage_key_vault_secret_id                    = optional(string)
    content_share_force_disabled                   = optional(bool, false)
    public_network_access_enabled                  = optional(bool, true)
    storage_uses_managed_identity                  = optional(bool)
    vnet_image_pull_enabled                        = optional(bool, false)
    key_vault_reference_identity_id                = optional(string)
    client_certificate_exclusion_paths             = optional(string)
    ftp_publish_basic_authentication_enabled       = optional(bool, true)
    webdeploy_publish_basic_authentication_enabled = optional(bool, true)
    virtual_network_backup_restore_enabled         = optional(bool, false)

    # flex-specific settings
    storage_container_type            = optional(string)
    storage_container_endpoint        = optional(string)
    storage_authentication_type       = optional(string)
    storage_access_key                = optional(string)
    storage_user_assigned_identity_id = optional(string)
    runtime_name                      = optional(string)
    runtime_version                   = optional(string)
    maximum_instance_count            = optional(number)
    instance_memory_in_mb             = optional(number, 512)
    http_concurrency                  = optional(number)
    always_ready = optional(map(object({
      name           = string
      instance_count = number
    })))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool, false)
      runtime_version                         = optional(string, "~1")
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string, "RedirectToLoginPage")
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool, true)
      http_route_api_prefix                   = optional(string, "/.auth")
      forward_proxy_convention                = optional(string, "NoProxy")
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      login = object({
        token_store_enabled               = optional(bool, false)
        token_refresh_extension_time      = optional(number)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
        preserve_url_fragments_for_logins = optional(bool)
        allowed_external_redirect_urls    = optional(list(string))
        cookie_expiration_convention      = optional(string)
        cookie_expiration_time            = optional(string)
        validate_nonce                    = optional(bool)
        nonce_expiration_time             = optional(string)
        logout_endpoint                   = optional(string)
      })
      apple_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string))
        jwt_allowed_client_applications      = optional(list(string))
        www_authentication_disabled          = optional(bool)
        allowed_audiences                    = optional(list(string))
        allowed_groups                       = optional(list(string))
        allowed_identities                   = optional(list(string))
        login_parameters                     = optional(map(string))
        allowed_applications                 = optional(list(string))
      }))
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }))
      custom_oidc_v2 = optional(map(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string)
        scopes                        = optional(list(string))
        client_credential_method      = optional(string)
        client_secret_setting_name    = optional(string)
        authorisation_endpoint        = optional(string)
        token_endpoint                = optional(string)
        issuer_endpoint               = optional(string)
        certification_uri             = optional(string)
      })), {})
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string, "v15.0")
        login_scopes            = optional(list(string))
      }))
      github_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      google_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      microsoft_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      twitter_v2 = optional(object({
        consumer_key                 = string
        consumer_secret_setting_name = string
      }))
    }))
    site_config = object({
      always_on                                     = optional(bool, false)
      ftps_state                                    = optional(string, "AllAllowed")
      worker_count                                  = optional(number)
      http2_enabled                                 = optional(bool, true)
      app_scale_limit                               = optional(number)
      app_command_line                              = optional(string)
      remote_debugging_version                      = optional(string)
      pre_warmed_instance_count                     = optional(number)
      runtime_scale_monitoring_enabled              = optional(bool, false)
      scm_use_main_ip_restriction                   = optional(bool, false)
      health_check_eviction_time_in_min             = optional(number)
      application_insights_connection_string        = optional(string)
      container_registry_use_managed_identity       = optional(bool, false)
      container_registry_managed_identity_client_id = optional(string)
      minimum_tls_version                           = optional(string, "1.2")
      api_management_api_id                         = optional(string)
      managed_pipeline_mode                         = optional(string)
      vnet_route_all_enabled                        = optional(bool, false)
      scm_minimum_tls_version                       = optional(string, "1.2")
      application_insights_key                      = optional(string)
      elastic_instance_minimum                      = optional(number)
      remote_debugging_enabled                      = optional(bool, false)
      default_documents                             = optional(list(string))
      health_check_path                             = optional(string)
      use_32_bit_worker                             = optional(bool, false)
      api_definition_url                            = optional(string)
      websockets_enabled                            = optional(bool, false)
      load_balancing_mode                           = optional(string)
      ip_restriction_default_action                 = optional(string, "Allow")
      scm_ip_restriction_default_action             = optional(string, "Allow")
      ip_restrictions = optional(map(object({
        action                    = optional(string, "Allow")
        ip_address                = optional(string)
        name                      = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers                   = optional(list(string), [])
      })), {})
      scm_ip_restrictions = optional(map(object({
        action                    = optional(string, "Allow")
        ip_address                = optional(string)
        name                      = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers                   = optional(list(string), [])
      })), {})
      application_stack = optional(object({
        dotnet_version              = optional(string)
        use_dotnet_isolated_runtime = optional(bool)
        java_version                = optional(string)
        node_version                = optional(string)
        python_version              = optional(string)
        powershell_core_version     = optional(string)
        use_custom_runtime          = optional(bool)
        docker = optional(object({
          image_name        = string
          image_tag         = string
          registry_url      = string
          registry_username = string
          registry_password = string
        }))
      }))
      cors = optional(object({
        allowed_origins     = optional(list(string), [])
        support_credentials = optional(bool, false)
      }))
      app_service_logs = optional(object({
        disk_quota_mb         = optional(number)
        retention_period_days = optional(number)
      }))
    })
    storage_accounts = optional(map(object({
      name         = optional(string)
      type         = string
      share_name   = string
      access_key   = string
      account_name = string
      mount_path   = optional(string)
    })), {})
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string), [])
      connection_string_names = optional(list(string), [])
    }))
    backup = optional(object({
      name                = string
      enabled             = optional(bool, true)
      storage_account_url = string
      schedule = object({
        frequency_unit           = string
        frequency_interval       = number
        retention_period_days    = optional(number)
        start_time               = optional(string)
        keep_at_least_one_backup = optional(bool, false)
      })
    }))
    connection_string = optional(map(object({
      name  = string
      type  = string
      value = string
    })), {})
    slots = optional(map(object({
      name                                           = optional(string)
      service_plan_id                                = optional(string)
      virtual_network_backup_restore_enabled         = optional(bool, false)
      storage_account_name                           = optional(string)
      storage_account_access_key                     = optional(string)
      webdeploy_publish_basic_authentication_enabled = optional(bool, true)
      ftp_publish_basic_authentication_enabled       = optional(bool, true)
      client_certificate_exclusion_paths             = optional(string)
      vnet_image_pull_enabled                        = optional(bool, false)
      content_share_force_disabled                   = optional(bool, false)
      storage_uses_managed_identity                  = optional(bool)
      public_network_access_enabled                  = optional(bool, true)
      storage_key_vault_secret_id                    = optional(string)
      functions_extension_version                    = optional(string)
      client_certificate_enabled                     = optional(bool, false)
      virtual_network_subnet_id                      = optional(string)
      daily_memory_time_quota                        = optional(number)
      client_certificate_mode                        = optional(string)
      builtin_logging_enabled                        = optional(bool, true)
      https_only                                     = optional(bool, true)
      enabled                                        = optional(bool, true)
      key_vault_reference_identity_id                = optional(string)
      app_settings                                   = optional(map(string))
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string))
      }))
      auth_settings_v2 = optional(object({
        auth_enabled                            = optional(bool, false)
        runtime_version                         = optional(string, "~1")
        config_file_path                        = optional(string)
        require_authentication                  = optional(bool)
        unauthenticated_action                  = optional(string, "RedirectToLoginPage")
        default_provider                        = optional(string)
        excluded_paths                          = optional(list(string))
        require_https                           = optional(bool, true)
        http_route_api_prefix                   = optional(string, "/.auth")
        forward_proxy_convention                = optional(string, "NoProxy")
        forward_proxy_custom_host_header_name   = optional(string)
        forward_proxy_custom_scheme_header_name = optional(string)
        login = object({
          token_store_enabled               = optional(bool, false)
          token_refresh_extension_time      = optional(number)
          token_store_path                  = optional(string)
          token_store_sas_setting_name      = optional(string)
          preserve_url_fragments_for_logins = optional(bool)
          allowed_external_redirect_urls    = optional(list(string))
          cookie_expiration_convention      = optional(string)
          cookie_expiration_time            = optional(string)
          validate_nonce                    = optional(bool)
          nonce_expiration_time             = optional(string)
          logout_endpoint                   = optional(string)
        })
        apple_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          login_scopes               = optional(list(string))
        }))
        active_directory_v2 = optional(object({
          client_id                            = string
          tenant_auth_endpoint                 = string
          client_secret_setting_name           = optional(string)
          client_secret_certificate_thumbprint = optional(string)
          jwt_allowed_groups                   = optional(list(string))
          jwt_allowed_client_applications      = optional(list(string))
          www_authentication_disabled          = optional(bool)
          allowed_audiences                    = optional(list(string))
          allowed_groups                       = optional(list(string))
          allowed_identities                   = optional(list(string))
          login_parameters                     = optional(map(string))
          allowed_applications                 = optional(list(string))
        }))
        azure_static_web_app_v2 = optional(object({
          client_id = string
        }))
        custom_oidc_v2 = optional(map(object({
          name                          = string
          client_id                     = string
          openid_configuration_endpoint = string
          name_claim_type               = optional(string)
          scopes                        = optional(list(string))
          client_credential_method      = optional(string)
          client_secret_setting_name    = optional(string)
          authorisation_endpoint        = optional(string)
          token_endpoint                = optional(string)
          issuer_endpoint               = optional(string)
          certification_uri             = optional(string)
        })), {})
        facebook_v2 = optional(object({
          app_id                  = string
          app_secret_setting_name = string
          graph_api_version       = optional(string, "v15.0")
          login_scopes            = optional(list(string))
        }))
        github_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          login_scopes               = optional(list(string))
        }))
        google_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          allowed_audiences          = optional(list(string))
          login_scopes               = optional(list(string))
        }))
        microsoft_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          allowed_audiences          = optional(list(string))
          login_scopes               = optional(list(string))
        }))
        twitter_v2 = optional(object({
          consumer_key                 = string
          consumer_secret_setting_name = string
        }))
      }))
      site_config = object({
        always_on                                     = optional(bool, false)
        ftps_state                                    = optional(string, "Disabled")
        worker_count                                  = optional(number)
        http2_enabled                                 = optional(bool, false)
        app_scale_limit                               = optional(number)
        app_command_line                              = optional(string)
        remote_debugging_version                      = optional(string)
        pre_warmed_instance_count                     = optional(number)
        runtime_scale_monitoring_enabled              = optional(bool, false)
        scm_use_main_ip_restriction                   = optional(bool, false)
        health_check_eviction_time_in_min             = optional(number)
        application_insights_connection_string        = optional(string)
        container_registry_use_managed_identity       = optional(bool, false)
        container_registry_managed_identity_client_id = optional(string)
        minimum_tls_version                           = optional(string, "1.2")
        api_management_api_id                         = optional(string)
        managed_pipeline_mode                         = optional(string)
        vnet_route_all_enabled                        = optional(bool, false)
        scm_minimum_tls_version                       = optional(string, "1.2")
        application_insights_key                      = optional(string)
        elastic_instance_minimum                      = optional(number)
        remote_debugging_enabled                      = optional(bool, false)
        default_documents                             = optional(list(string))
        health_check_path                             = optional(string)
        use_32_bit_worker                             = optional(bool, false)
        api_definition_url                            = optional(string)
        auto_swap_slot_name                           = optional(string)
        websockets_enabled                            = optional(bool, false)
        load_balancing_mode                           = optional(string)
        scm_ip_restriction_default_action             = optional(string, "Allow")
        ip_restriction_default_action                 = optional(string, "Allow")
        ip_restrictions = optional(map(object({
          action                    = optional(string, "Allow")
          ip_address                = optional(string)
          name                      = optional(string)
          priority                  = optional(number, 65000)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers                   = optional(list(string), [])
        })), {})
        scm_ip_restrictions = optional(map(object({
          action                    = optional(string, "Allow")
          ip_address                = optional(string)
          name                      = optional(string)
          priority                  = optional(number, 65000)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers                   = optional(list(string), [])
        })), {})
        application_stack = optional(object({
          dotnet_version              = optional(string)
          use_dotnet_isolated_runtime = optional(bool)
          java_version                = optional(string)
          node_version                = optional(string)
          python_version              = optional(string)
          powershell_core_version     = optional(string)
          use_custom_runtime          = optional(bool)
          docker = optional(object({
            image_name        = string
            image_tag         = string
            registry_url      = string
            registry_username = string
            registry_password = string
          }))
        }))
        cors = optional(object({
          allowed_origins     = optional(list(string), [])
          support_credentials = optional(bool, false)
        }))
        app_service_logs = optional(object({
          disk_quota_mb         = optional(number)
          retention_period_days = optional(number)
        }))
      })
      storage_accounts = optional(map(object({
        name         = optional(string)
        type         = string
        share_name   = string
        access_key   = string
        account_name = string
        mount_path   = optional(string)
      })), {})
      connection_strings = optional(map(object({
        name  = optional(string)
        value = string
        type  = string
      })), {})
      backup = optional(object({
        name                = string
        storage_account_url = string
        enabled             = optional(bool, true)
        schedule = object({
          frequency_interval       = number
          frequency_unit           = string
          keep_at_least_one_backup = optional(bool, false)
          retention_period_days    = optional(number, 30)
          start_time               = optional(string)
          last_execution_time      = optional(string)
        })
      }))
    })), {})
  })
  validation {
    condition     = var.instance.location != null || var.location != null
    error_message = "location must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = contains(["windows", "linux", "flex"], lookup(var.instance, "type", ""))
    error_message = "The type must be either 'windows', 'linux' or 'flex'."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Default resource group name"
  type        = string
  default     = null
}

variable "location" {
  description = "Default location"
  type        = string
  default     = null
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
  default     = {}
}
