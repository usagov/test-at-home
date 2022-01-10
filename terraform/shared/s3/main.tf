###
# Target space/org
###

data "cloudfoundry_space" "space" {
  org_name = var.cf_org_name
  name     = var.cf_space_name
}

###
# S3 instance
###

data "cloudfoundry_service" "s3" {
  name = "s3"
}

resource "cloudfoundry_service_instance" "bucket" {
  name             = var.s3_service_name
  space            = data.cloudfoundry_space.space.id
  service_plan     = data.cloudfoundry_service.s3.service_plans[var.s3_plan_name]
  recursive_delete = var.recursive_delete
}

resource "cloudfoundry_service_key" "bucket_creds" {
  name             = "${var.s3_service_name}-access"
  service_instance = cloudfoundry_service_instance.bucket.id
}

output "bucket_credentials" {
  value = cloudfoundry_service_key.bucket_creds.credentials
}
