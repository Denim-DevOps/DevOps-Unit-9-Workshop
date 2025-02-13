terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.43.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id = "9734ed68-621d-47ed-babd-269110dbacb1"
}

data "azurerm_resource_group" "main" {
  name = "1-a2d84e1e-playground-sandbox"
}

resource "azurerm_service_plan" "main" {
  name                = "denims-terraformed-asp"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "main" {
  name                = "denims-terraformed-app-service"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name     = "corndeldevopscourse/mod12app:latest"
      docker_registry_url   = "https://index.docker.io"
    }
  }

  app_settings = {
    "DEPLOYMENT_METHOD" : "Terraform"
    "CONNECTION_STRING" : "Server=tcp:denim-non-iac-sqlserver.database.windows.net,1433;Initial Catalog=denim-non-iac-db;Persist Security Info=False;User ID=dbadmin;Password=${var.database_password};...;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
