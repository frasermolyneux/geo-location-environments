resource "azurerm_role_assignment" "webapp_to_kv_role_assignment" {
  for_each = { for each in local.configs : each.label => each }

  scope                = azurerm_key_vault.config_kv[each.value.label].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.webapp_identity.principal_id
}

resource "azurerm_role_assignment" "webapi_to_kv_role_assignment" {
  for_each = { for each in local.configs : each.label => each }

  scope                = azurerm_key_vault.config_kv[each.value.label].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.webapi_identity.principal_id
}

resource "azuread_app_role_assignment" "webapp_to_lookup_api" {
  app_role_id         = azuread_service_principal.geolocation_api_service_principal.app_roles[index(azuread_service_principal.geolocation_api_service_principal.app_roles.*.display_name, "LookupApiUser")].id
  principal_object_id = azurerm_user_assigned_identity.webapp_identity.principal_id
  resource_object_id  = azuread_service_principal.geolocation_api_service_principal.object_id
}
