# Test harness: wraps the module as a child so terraform test can plan it
# without requiring the module's own outputs to be marked sensitive.

terraform {
  # override_during = plan in the test files needs terraform 1.11 or newer
  required_version = "~> 1.11"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# any: pass-through to the module's own typed object, so the harness does not
# have to restate the full type
variable "function_app" {
  type = any
}

module "func" {
  source = "../.."

  resource_group_name = "rg-test"
  location            = "westeurope"
  function_app        = var.function_app
}
