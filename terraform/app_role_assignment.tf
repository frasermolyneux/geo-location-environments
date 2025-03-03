resource "azuread_app_role_assignment" "webapp_to_lookup_api" {
  app_role_id         = azuread_service_principal.geolocation_api_service_principal.app_roles[index(azuread_service_principal.geolocation_api_service_principal.app_roles.*.display_name, "LookupApiUser")].id
  principal_object_id = azurerm_user_assigned_identity.webapp_identity.principal_id
  resource_object_id  = azuread_service_principal.geolocation_api_service_principal.object_id
}
