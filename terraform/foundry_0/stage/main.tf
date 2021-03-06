module "database" {
  source = "../../shared/database"

  aws_region       = "us-gov-west-1"
  cf_api_url       = "https://api.fr.cloud.gov"
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_org_name      = "tts-usps-test-at-home"
  cf_space_name    = "staging"
  env              = "stage"
  recursive_delete = true
  rds_plan_name    = "micro-psql"
}
