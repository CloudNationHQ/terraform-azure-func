This example showcases application slots using different configurations.

## Usage

```hcl
module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.2"

  instance = {
    type          = "linux"
    name          = "func-demo-dev-xaew"
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    storage_account_name       = module.storage.account.name
    storage_account_access_key = module.storage.account.primary_access_key
    service_plan_id            = module.serviceplan.plans.plan1.id
    slots                      = local.slots

    site_config = {
      always_on                        = false
      pre_warmed_instance_count        = 3
      runtime_scale_monitoring_enabled = true
      scm_use_main_ip_restriction      = true
      application_stack = {
        node_version = "14"
      }
      app_service_logs = {
        disk_quota_mb         = 100
        retention_period_days = 30
      }
      environment_variables = {
        NODE_ENV = "production"
      }
    }
  }
}
```

The module uses the below locals for configuration:

```hcl
locals {
  slots = {
    dev = {
      name = "development"
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
      name = "staging"
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
```
