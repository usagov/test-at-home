module "database" {
  source = "../shared/database"

  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_space_name    = "tah-stage"
  env              = "stage"
  recursive_delete = true
  rds_plan_name    = "medium-gp-psql-redundant"
}
