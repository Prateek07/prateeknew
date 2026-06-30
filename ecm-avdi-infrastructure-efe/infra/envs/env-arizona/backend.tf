terraform {

  backend "azurerm" {

    use_oidc         = true

    environment = "usgovernment"

  }

}