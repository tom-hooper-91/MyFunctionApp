resource "azurerm_resource_group" "main" {
  name     = "tom-hooper-rg"
  location = local.location
}

resource "azurerm_service_plan" "main" {
  name                = "tom-hooper-service-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_storage_account" "main" {
  name                     = "tomhooperstorageaccount"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version = "TLS1_2"
}