# Verifies that function_app.ignore_auth_settings_v2 selects the resource
# variant whose lifecycle ignores auth_settings_v2, that the default keeps the
# existing resource addresses (no recreate for current consumers), and that
# slots and functions follow whichever variant is live.
#
# The module is planned through tests/harness so its outputs are not root
# outputs (terraform test would otherwise require them to be marked
# sensitive). Each variant is stamped with a recognisable id so the outputs
# reveal which resource produced them (ids must be well-formed site ids:
# the slot and function resources validate function_app_id).

mock_provider "azurerm" {}

override_resource {
  target          = module.func.azurerm_linux_function_app.this
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-this" }
}
override_resource {
  target          = module.func.azurerm_linux_function_app.ignore_auth
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-ignore-auth" }
}
override_resource {
  target          = module.func.azurerm_windows_function_app.this
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-windows-this" }
}
override_resource {
  target          = module.func.azurerm_windows_function_app.ignore_auth
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-windows-ignore-auth" }
}
override_resource {
  target          = module.func.azurerm_function_app_flex_consumption.this
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-flex-this" }
}
override_resource {
  target          = module.func.azurerm_function_app_flex_consumption.ignore_auth
  override_during = plan
  values          = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-flex-ignore-auth" }
}

run "default_keeps_existing_address" {
  command = plan
  module {
    source = "./tests/harness"
  }

  variables {
    function_app = {
      name                       = "func-test"
      type                       = "linux"
      service_plan_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/plan-test"
      storage_account_name       = "sttest"
      storage_account_access_key = "key"
      site_config                = {}
      slots = {
        dev = {
          name                       = "dev"
          storage_account_name       = "sttest"
          storage_account_access_key = "key"
          site_config                = {}
        }
      }
      functions = {
        hello = { config_json = "{}" }
      }
    }
  }

  assert {
    condition     = module.func.function_app.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-this"
    error_message = "default must keep azurerm_linux_function_app.this"
  }

  assert {
    condition     = module.func.slots["dev"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-this"
    error_message = "slot must reference azurerm_linux_function_app.this by default"
  }

  assert {
    condition     = module.func.functions["hello"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-this"
    error_message = "function must reference azurerm_linux_function_app.this by default"
  }
}

run "flag_selects_linux_variant" {
  command = plan
  module {
    source = "./tests/harness"
  }

  variables {
    function_app = {
      name                       = "func-test"
      type                       = "linux"
      service_plan_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/plan-test"
      storage_account_name       = "sttest"
      storage_account_access_key = "key"
      site_config                = {}
      ignore_auth_settings_v2    = true
      slots = {
        dev = {
          name                       = "dev"
          storage_account_name       = "sttest"
          storage_account_access_key = "key"
          site_config                = {}
        }
      }
      functions = {
        hello = { config_json = "{}" }
      }
    }
  }

  assert {
    condition     = module.func.function_app.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-ignore-auth"
    error_message = "ignore_auth_settings_v2 = true must select azurerm_linux_function_app.ignore_auth"
  }

  assert {
    condition     = module.func.slots["dev"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-ignore-auth"
    error_message = "slot must follow the ignore_auth variant"
  }

  assert {
    condition     = module.func.functions["hello"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-linux-ignore-auth"
    error_message = "function must follow the ignore_auth variant"
  }
}

run "flag_selects_windows_variant" {
  command = plan
  module {
    source = "./tests/harness"
  }

  variables {
    function_app = {
      name                       = "func-test"
      type                       = "windows"
      service_plan_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/plan-test"
      storage_account_name       = "sttest"
      storage_account_access_key = "key"
      site_config                = {}
      ignore_auth_settings_v2    = true
      slots = {
        dev = {
          name                       = "dev"
          storage_account_name       = "sttest"
          storage_account_access_key = "key"
          site_config                = {}
        }
      }
      functions = {
        hello = { config_json = "{}" }
      }
    }
  }

  assert {
    condition     = module.func.function_app.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-windows-ignore-auth"
    error_message = "ignore_auth_settings_v2 = true must select azurerm_windows_function_app.ignore_auth"
  }

  assert {
    condition     = module.func.slots["dev"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-windows-ignore-auth"
    error_message = "slot must follow the ignore_auth variant"
  }

  assert {
    condition     = module.func.functions["hello"].function_app_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-windows-ignore-auth"
    error_message = "function must follow the ignore_auth variant"
  }
}

run "flag_selects_flex_variant" {
  command = plan
  module {
    source = "./tests/harness"
  }

  variables {
    function_app = {
      name                        = "func-test"
      type                        = "flex"
      service_plan_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/plan-test"
      storage_container_type      = "blobContainer"
      storage_container_endpoint  = "https://sttest.blob.core.windows.net/deployments"
      storage_authentication_type = "StorageAccountConnectionString"
      storage_access_key          = "key"
      runtime_name                = "node"
      runtime_version             = "20"
      site_config                 = {}
      ignore_auth_settings_v2     = true
    }
  }

  assert {
    condition     = module.func.function_app.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/func-flex-ignore-auth"
    error_message = "ignore_auth_settings_v2 = true must select azurerm_function_app_flex_consumption.ignore_auth"
  }
}
