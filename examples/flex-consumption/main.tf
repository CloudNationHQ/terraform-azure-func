module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    blob_properties = {
      containers = {
        flexcontainer = {
          container_access_type = "private"
        }
      }
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
      sku_name       = "FC1"
    }
  }
}

module "flex_function" {
  source  = "cloudnationhq/func/azure"
  version = "~> 3.0"

  instance = {
    name                = "func-demo-dev-xaehqwgwbm"
    type                = "flex"
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    service_plan_id     = module.service_plan.plans.plan1.id

    storage_container_type      = "blobContainer"
    storage_container_endpoint  = "${module.storage.account.primary_blob_endpoint}${module.storage.containers.flexcontainer.name}"
    storage_authentication_type = "StorageAccountConnectionString"
    storage_access_key          = module.storage.account.primary_access_key

    runtime_name    = "node"
    runtime_version = "20"

    maximum_instance_count = 40
    instance_memory_in_mb  = 2048

    https_only                    = true
    enabled                       = true
    public_network_access_enabled = true

    app_settings = {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
    }

    site_config = {
      application_insights_connection_string = null
      application_insights_key               = null
      health_check_path                      = null
      health_check_eviction_time_in_min      = null
      http2_enabled                          = true
      minimum_tls_version                    = "1.2"
      websockets_enabled                     = false
      vnet_route_all_enabled                 = false
    }
  }
}