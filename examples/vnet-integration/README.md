This example highlights function app vnet integration

## Usage

```hcl
module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.2"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "func-demo-dev-xaeso"
    storage_account_name          = module.storage.account.name
    storage_account_access_key    = module.storage.account.primary_access_key
    service_plan_id               = module.serviceplan.plans.plan1.id
    virtual_network_subnet_id     = module.network.subnets.sn1.id
    public_network_access_enabled = false

    site_config = {
    }
  }
}
```
