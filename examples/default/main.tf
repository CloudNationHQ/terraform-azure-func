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

module "serviceplan" {
  source  = "cloudnationhq/func/azure//modules/serviceplan"
  version = "~> 0.1"

  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  plans = {
    plan1 = {
      name     = "app-service-plan-l"
      os_type  = "Linux"
      sku_name = "Y1"
    }
  }
}

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
