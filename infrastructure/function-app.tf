resource "azurerm_linux_function_app" "db" {
  name                = "tom-hooper-linux-function-app"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  storage_account_name = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

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
  app_id   = azurerm_linux_function_app.db.id
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