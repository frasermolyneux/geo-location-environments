resource "random_uuid" "app_role_lookup_api_user" {
}

resource "azuread_application" "geolocation_api_application" {
  display_name     = local.app_registration_name
  identifier_uris  = [format("api://%s", local.app_registration_name)]
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  app_role {
    allowed_member_types = ["Application"]
    description          = "Lookup API Users can perform lookup requests against the service"
    display_name         = "LookupApiUser"
    enabled              = true
    id                   = random_uuid.app_role_lookup_api_user.result
    value                = "LookupApiUser"
  }
}

resource "azuread_service_principal" "geolocation_api_service_principal" {
  client_id                    = azuread_application.geolocation_api_application.client_id
  app_role_assignment_required = false

  owners = [
    data.azuread_client_config.current.object_id
  ]
}
