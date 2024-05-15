module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

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

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 0.1"

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

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 2.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      sn1 = {
        nsg  = {}
        cidr = ["10.18.1.0/24"]
      }
    }
  }
}

module "serviceplan" {
  source  = "cloudnationhq/func/azure//modules/serviceplan"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  plans = {
    plan1 = {
      name     = module.naming.app_service_plan.name
      os_type  = "Linux"
      sku_name = "P1v2"
      reserved = true
    }
  }
}

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
