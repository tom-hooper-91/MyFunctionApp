resource "azurerm_resource_group" "function_app" {
  name     = "tom-hooper-rg"
  location = "West Europe"
}

resource "azurerm_service_plan" "function_app" {
  name                = "tom-hooper-service-plan"
  resource_group_name = azurerm_resource_group.function_app.name
  location            = azurerm_resource_group.function_app.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_storage_account" "function_app" {
  name                     = "tomhooperstorageaccount"
  resource_group_name      = azurerm_resource_group.function_app.name
  location                 = azurerm_resource_group.function_app.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version = "TLS1_2"
}

resource "azurerm_linux_function_app" "example" {
  name                = "tom-hooper-linux-function-app"
  resource_group_name = azurerm_resource_group.function_app.name
  location            = azurerm_resource_group.function_app.location
  service_plan_id     = azurerm_service_plan.function_app.id

  storage_account_name = azurerm_storage_account.function_app.name
  storage_account_access_key = azurerm_storage_account.function_app.primary_access_key

  site_config {
    always_on = false
    application_stack {
        dotnet_version = "6.0"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_source_control" "function_app" {
  app_id   = azurerm_linux_function_app.example.id
  repo_url = "https://github.com/tom-hooper-91/MyFunctionApp"
  branch   = "main"

  github_action_configuration {
    generate_workflow_file = true
    code_configuration {
        runtime_stack = "dotnetcore"
        runtime_version = "6.0"
    }
  }
}

resource "azurerm_source_control_token" "function_app" {
  type         = "GitHub"
  token        = var.github_auth_token
}