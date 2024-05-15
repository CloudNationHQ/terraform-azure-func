This example highlights a windows function app.

## Usage

```hcl
module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.2"

  instance = {
    type          = "windows"
    name          = "func-demo-dev-xaesdwq"
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    storage_account_name       = module.storage.account.name
    storage_account_access_key = module.storage.account.primary_access_key
    service_plan_id            = module.serviceplan.plans.plan1.id

    site_config = {
      pre_warmed_instance_count        = 3
      runtime_scale_monitoring_enabled = true
      application_stack = {
        node_version = "~20"
      }
      app_service_logs = {
        disk_quota_mb         = 100
        retention_period_days = 30
      }
    }
  }
}
```
