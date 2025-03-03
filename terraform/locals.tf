locals {
  resource_group_name    = "rg-geolocation-environments-${var.environment}-${var.location}"
  app_configuration_name = "appcs-geolocation-${var.environment}-${var.location}"
  webapp_identity_name   = "id-geolocation-webapp-${var.environment}"
  webapi_identity_name   = "id-geolocation-webapi-${var.environment}"
  app_registration_name  = "geolocation-api-${var.environment}"
}

locals {
  json_files = [for config in var.app_configs : jsondecode(file("app_configs/${config}.json"))]

  configs = [for content in local.json_files : {
    label = content.label,
    keys = [for key in lookup(content, "keys", []) : {
      key   = key.key,
      value = lookup(key, "value", "")
    }]
    secret_keys = [for key in lookup(content, "secret_keys", []) : {
      key        = key.key
      expiration = lookup(key, "expiration", null)
    }]
  }]

  config_keys = flatten([
    for config in local.configs : [
      for key in config.keys : {
        key      = format("%s-%s", config.label, key.key)
        label    = config.label
        key_name = key.key
        value    = key.value
      }
    ]
  ])

  config_secret_keys = flatten([
    for config in local.configs : [
      for key in config.secret_keys : {
        key        = format("%s-%s", config.label, key.key)
        label      = config.label
        key_name   = key.key
        expiration = key.expiration
      }
    ]
  ])
}
