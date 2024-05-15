This example details a function app setup with a private endpoint, enhancing security by restricting data access to a private network.

## Usage:

```hcl
module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 0.2"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  endpoints = {
    func = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.function_app.instance.id
      private_dns_zone_ids           = [module.private_dns.zones.web.id]
      subresource_names              = ["sites"]
    }
  }
}
```

```hcl
module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name

  zones = {
    web = {
      name = "privatelink.azurewebsites.net"
      virtual_network_links = {
        link1 = {
          virtual_network_id   = module.network.vnet.id
          registration_enabled = true
        }
      }
    }
  }
}
```

```hcl
module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "func-demo-dev-xaeh"
    storage_account_name          = module.storage.account.name
    storage_account_access_key    = module.storage.account.primary_access_key
    service_plan_id               = module.serviceplan.plans.plan1.id
    public_network_access_enabled = false

    site_config = {
    }
  }
}
```
