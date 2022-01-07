###
# Target spaces
###

data "cloudfoundry_space" "prod" {
  org_name = "tts-usps-test-at-home"
  name     = "tah-prod"
}

data "cloudfoundry_service" "s3" {
  name = "s3"
}

###
# config S3 bucket
###

resource "cloudfoundry_service_instance" "shared_config_bucket" {
  name             = "tah-shared-config"
  space            = data.cloudfoundry_space.prod.id
  service_plan     = data.cloudfoundry_service.s3.service_plans["basic"]
  recursive_delete = false
}

resource "cloudfoundry_service_key" "config_bucket_creds" {
  name             = "config-bucket-access"
  service_instance = cloudfoundry_service_instance.shared_config_bucket.id
}

output "bucket_credentials" {
  value = cloudfoundry_service_key.config_bucket_creds.credentials
}
