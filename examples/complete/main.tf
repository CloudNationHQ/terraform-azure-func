module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 2.0"

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        nsg  = {}
        delegations = {
          web = {
            name = "Microsoft.Web/serverFarms"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
      }
      sn2 = {
        nsg  = {}
        cidr = ["10.18.2.0/24"]
      }
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 3.0"

  resource_group = module.rg.groups.demo.name

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

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  endpoints = {
    func = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn2.id
      private_connection_resource_id = module.function_app.instance.id
      private_dns_zone_ids           = [module.private_dns.zones.web.id]
      subresource_names              = ["sites"]
    }
  }
}

module "service_plan" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 2.0"

  plans = {
    plan1 = {
      name           = module.naming.app_service_plan.name
      resource_group = module.rg.groups.demo.name
      location       = module.rg.groups.demo.location
      os_type        = "Linux"
      sku_name       = "EP1"
      kind           = "functionapp"
    }
  }
}

module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "func-demo-dev-xaeso"
    storage_account_name          = module.storage.account.name
    storage_account_access_key    = module.storage.account.primary_access_key
    service_plan_id               = module.service_plan.plans.plan1.id
    virtual_network_subnet_id     = module.network.subnets.sn1.id
    public_network_access_enabled = false
    slots                         = local.slots

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
