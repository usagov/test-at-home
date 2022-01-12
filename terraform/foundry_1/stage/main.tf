module "database" {
  source = "../../shared/database"

  aws_region       = "us-gov-west-1"
  cf_api_url       = "https://api.fr.wb.cloud.gov"
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_org_name      = "gsa-tts-test-kits"
  cf_space_name    = "tah-stage"
  env              = "stage"
  recursive_delete = true
  rds_plan_name    = "xlarge-gp-psql-redundant"
}
