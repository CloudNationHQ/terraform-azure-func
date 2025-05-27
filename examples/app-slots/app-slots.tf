locals {
  slots = {
    dev = {
      name                       = "development"
      storage_account_name       = module.storage.account.name
      storage_account_access_key = module.storage.account.primary_access_key
      site_config = {
        always_on                        = false
        http2_enabled                    = true
        app_command_line                 = ""
        pre_warmed_instance_count        = 1
        runtime_scale_monitoring_enabled = false
        scm_use_main_ip_restriction      = false
        minimum_tls_version              = "1.2"
        remote_debugging_enabled         = true
        use_32_bit_worker                = true
        websockets_enabled               = true
        application_stack = {
          node_version = "14"
        }
        cors = {
          allowed_origins = ["https://localhost:3000"]
        }
        app_service_logs = {
          disk_quota_mb         = 35
          retention_period_days = 7
        }
        environment_variables = {
          NODE_ENV = "development"
        }
      }
    }
    staging = {
      name                       = "staging"
      storage_account_name       = module.storage.account.name
      storage_account_access_key = module.storage.account.primary_access_key
      site_config = {
        always_on                        = false
        http2_enabled                    = true
        app_command_line                 = ""
        pre_warmed_instance_count        = 2
        runtime_scale_monitoring_enabled = true
        scm_use_main_ip_restriction      = true
        minimum_tls_version              = "1.2"
        remote_debugging_enabled         = false
        use_32_bit_worker                = false
        websockets_enabled               = true
        application_stack = {
          node_version = "14"
        }
        cors = {
          allowed_origins = ["https://staging.example.com"]
        }
        app_service_logs = {
          disk_quota_mb         = 50
          retention_period_days = 14
        }
        environment_variables = {
          NODE_ENV = "staging"
        }
      }
    }
  }
}
