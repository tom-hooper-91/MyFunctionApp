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

  site_config {}
}