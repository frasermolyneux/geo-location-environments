resource "azurerm_user_assigned_identity" "webapp_identity" {
  name = local.webapp_identity_name

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "webapi_identity" {
  name = local.webapi_identity_name

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
