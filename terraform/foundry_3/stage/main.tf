module "database" {
  source = "../../shared/database"

  aws_region       = "us-gov-east-1"
  cf_api_url       = "https://api.fr.ea.cloud.gov"
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_org_name      = "gsa-tts-test-kits"
  cf_space_name    = "staging"
  env              = "stage"
  recursive_delete = true
  rds_plan_name    = "xlarge-gp-psql-redundant"
}
