locals {
  aws_region       = "us-gov-east-1"
  cf_api_url       = "https://api.fr.ea.cloud.gov"
  cf_org_name      = "gsa-tts-test-kits"
  cf_space_name    = "prod"
  env              = "prod"
  recursive_delete = false
}

module "database-n" {
  source = "../../shared/database-n"

  aws_region       = local.aws_region
  cf_api_url       = local.cf_api_url
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_org_name      = local.cf_org_name
  cf_space_name    = local.cf_space_name
  env              = local.env
  db_count         = 10
  recursive_delete = local.recursive_delete
  rds_plan_name    = "xlarge-gp-psql-redundant"
}

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
  json_params      = "{\"domains\": \"covidtest.usa.gov\", \"origin\": \"route.covidtest.usa.gov\"}"
}

# The following lines need to be commented out for the initial `terraform apply`
# and then re-enabled and applied after the app has first been deployed
# module "domain" {
#   source = "../../shared/domain"
#
#   aws_region             = local.aws_region
#   cf_api_url             = local.cf_api_url
#   cf_user                = var.cf_user
#   cf_password            = var.cf_password
#   cf_org_name            = local.cf_org_name
#   cf_space_name          = local.cf_space_name
#   env                    = local.env
#   recursive_delete       = local.recursive_delete
#   global_domain_name     = "covidtest.usa.gov"
#   origin_domain_name     = "route.covidtest.usa.gov"
#   regional_domain_name   = "east.covidtest.usa.gov"
#   foundation_domain_name = "easta.covidtest.usa.gov"
# }
