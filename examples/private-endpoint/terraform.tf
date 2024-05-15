terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "~> 3.61"
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}
