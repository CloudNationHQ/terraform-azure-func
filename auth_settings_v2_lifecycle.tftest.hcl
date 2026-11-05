# Verifies the behaviour the ignore_auth variants exist for: with
# ignore_auth_settings_v2 = true, auth_settings_v2 is applied once at creation
# and later changes to it are ignored, which is what stops the module from
# removing the block azure writes when the app is a static web app backend.
# The default variant is asserted alongside it, so the pair fails if the extra
# ignore_changes entry is ever dropped.
#
# The module is planned through tests/harness so its outputs are not root
# outputs (terraform test would otherwise require them to be marked sensitive).

mock_provider "azurerm" {}

variables {
  applied_auth = {
    auth_enabled           = true
    require_authentication = true
    unauthenticated_action = "RedirectToLoginPage"
    login                  = {}
    azure_static_web_app_v2 = {
      client_id = "swa-applied.azurestaticapps.net"
    }
  }
  changed_auth = {
    auth_enabled           = false
    require_authentication = false
    unauthenticated_action = "AllowAnonymous"
    login                  = {}
    azure_static_web_app_v2 = {
      client_id = "swa-changed.azurestaticapps.net"
    }
  }
}

run "create_with_flag" {
  command = apply
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
      auth_settings_v2           = var.applied_auth
    }
  }

  assert {
    condition     = module.func.function_app.auth_settings_v2[0].azure_static_web_app_v2[0].client_id == "swa-applied.azurestaticapps.net"
    error_message = "auth_settings_v2 must still be applied when the app is created"
  }
}

run "change_is_ignored_with_flag" {
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
      auth_settings_v2           = var.changed_auth
    }
  }

  assert {
    condition     = module.func.function_app.auth_settings_v2[0].azure_static_web_app_v2[0].client_id == "swa-applied.azurestaticapps.net"
    error_message = "with ignore_auth_settings_v2 = true the applied auth_settings_v2 must survive, so azure's block is never removed"
  }
}

run "create_without_flag" {
  command = apply
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
      auth_settings_v2           = var.applied_auth
    }
  }

  assert {
    condition     = module.func.function_app.auth_settings_v2[0].azure_static_web_app_v2[0].client_id == "swa-applied.azurestaticapps.net"
    error_message = "auth_settings_v2 must be applied on the default variant too"
  }
}

run "change_is_tracked_without_flag" {
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
      auth_settings_v2           = var.changed_auth
    }
  }

  assert {
    condition     = module.func.function_app.auth_settings_v2[0].azure_static_web_app_v2[0].client_id == "swa-changed.azurestaticapps.net"
    error_message = "without the flag the module must still manage auth_settings_v2 changes"
  }
}
