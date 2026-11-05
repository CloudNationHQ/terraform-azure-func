module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name = module.naming.resource_group.name_unique
      # static web apps are not offered in swedencentral, which the other examples use
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 5.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "service_plan" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 4.0"

  plans = {
    plan1 = {
      name                = module.naming.app_service_plan.name
      resource_group_name = module.rg.groups.demo.name
      location            = module.rg.groups.demo.location
      os_type             = "Linux"
      sku_name            = "B1"
    }
  }
}

module "function_app" {
  source  = "cloudnationhq/func/azure"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  function_app = {
    type                       = "linux"
    name                       = module.naming.function_app.name_unique
    storage_account_name       = module.storage.account.name
    storage_account_access_key = module.storage.account.primary_access_key
    service_plan_id            = module.service_plan.plans.plan1.id

    # azure manages auth_settings_v2 once the app is a static web app backend
    ignore_auth_settings_v2 = true

    app_settings = {
      "FUNCTIONS_WORKER_RUNTIME" = "node"
    }

    site_config = {
      application_stack = {
        node_version = "20"
      }
    }
  }
}

module "stapp" {
  source  = "cloudnationhq/stapp/azure"
  version = "~> 2.0"

  app = {
    name                = module.naming.static_web_app.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    sku_tier = "Standard"
    sku_size = "Standard"

    function_app_registration = {
      function_app_id = module.function_app.function_app.id
    }
  }
}
