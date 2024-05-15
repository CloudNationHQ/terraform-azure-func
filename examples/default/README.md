This example illustrates the default setup, in its simplest form.

## Usage: default

```hcl
module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  instance = {
    type                       = "linux"
    name                       = "func-demo-dev-xaen"
    storage_account_name       = module.storage.account.name
    storage_account_access_key = module.storage.account.primary_access_key
    service_plan_id            = module.serviceplan.plans.plan1.id

    site_config = {}
  }
}
```
