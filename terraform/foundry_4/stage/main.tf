locals {
  aws_region       = "us-gov-east-1"
  cf_api_url       = "https://api.fr.eb.cloud.gov"
  cf_org_name      = "gsa-tts-test-kits"
  cf_space_name    = "staging"
  env              = "stage"
  recursive_delete = true
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
  db_count         = 2
  recursive_delete = local.recursive_delete
  rds_plan_name    = "xlarge-gp-psql-redundant"
}

# The following lines need to be commented out for the initial `terraform apply`
# and then re-enabled and applied after the app has first been deployed
module "domain" {
  source = "../../shared/domain"

  aws_region             = local.aws_region
  cf_api_url             = local.cf_api_url
  cf_user                = var.cf_user
  cf_password            = var.cf_password
  cf_org_name            = local.cf_org_name
  cf_space_name          = local.cf_space_name
  env                    = local.env
  recursive_delete       = local.recursive_delete
  global_domain_name     = "staging-covidtest.usa.gov"
  origin_domain_name     = "route.staging-covidtest.usa.gov"
  regional_domain_name   = "east.staging-covidtest.usa.gov"
  foundation_domain_name = "eastb.staging-covidtest.usa.gov"
}
