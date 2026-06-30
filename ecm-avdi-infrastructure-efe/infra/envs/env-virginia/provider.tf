terraform {

  required_version = ">= 1.6.6, < 2.0.0"
 
  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"

      version = "~> 4.0"

    }

  }

}
 
provider "azurerm" {

  features {}
 
  environment = "usgovernment"

  use_oidc = true

  use_cli  = false

  resource_provider_registrations = "none"



}
 