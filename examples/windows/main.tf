module "naming" {
  source  = "CloudNationHQ/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "CloudNationHQ/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "storage" {
  source  = "CloudNationHQ/sa/azure"
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
      name     = module.naming.app_service_plan.name
      os_type  = "Windows"
      sku_name = "EP1"
    }
  }
}

module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 0.1"

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
