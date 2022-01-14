locals {
  cf_org_name      = "gsa-tts-test-kits"
  cf_space_name    = "staging"
  env              = "stage"
  recursive_delete = true
}

# module "database" {
#   source = "../../shared/database"
#
#   aws_region       = var.aws_region
#   cf_api_url       = var.cf_api_url
#   cf_user          = var.cf_user
#   cf_password      = var.cf_password
#   cf_org_name      = local.cf_org_name
#   cf_space_name    = local.cf_space_name
#   env              = local.env
#   recursive_delete = local.recursive_delete
#   rds_plan_name    = "xlarge-gp-psql-redundant"
# }

#######
# Set up CDN, only exists in this foundation
#######

data "cloudfoundry_space" "space" {
  org_name = local.cf_org_name
  name     = local.cf_space_name
}

data "cloudfoundry_service" "external_domain" {
  name = "external-domain"
}

resource "cloudfoundry_service_instance" "cdn_instance" {
  name             = "cdn-${local.env}"
  space            = data.cloudfoundry_space.space.id
  service_plan     = data.cloudfoundry_service.external_domain.service_plans["domain-with-cdn"]
  recursive_delete = local.recursive_delete
  json_params      = "{\"domains\": \"staging-covidtest.usa.gov\", \"origin\": \"route.staging-covidtest.usa.gov\"}"
}
