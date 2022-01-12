module "database-primary" {
  source = "../../shared/database"

  aws_region       = "us-gov-west-1"
  cf_api_url       = "https://api.fr.cloud.gov"
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_space_name    = "ryan.ahearn"
  cf_org_name      = "sandbox-gsa"
  env              = "stage"
  recursive_delete = true
  rds_plan_name    = "micro-psql"
}

module "database-shard-1" {
  source = "../../shared/database"

  aws_region       = "us-gov-west-1"
  cf_api_url       = "https://api.fr.cloud.gov"
  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_space_name    = "ryan.ahearn"
  cf_org_name      = "sandbox-gsa"
  env              = "stage-shard-1"
  recursive_delete = true
  rds_plan_name    = "micro-psql"
}
