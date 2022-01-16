###
# Target space/org
###

data "cloudfoundry_space" "space" {
  org_name = var.cf_org_name
  name     = var.cf_space_name
}

###
# RDS instance
###

data "cloudfoundry_service" "rds" {
  name = "aws-rds"
}

# not using the single db module anymore, commenting here lets each stage using the module
# delete the resource, after which this can all be cleaning up
# resource "cloudfoundry_service_instance" "rds" {
#   name             = "test_at_home-rds-${var.env}"
#   space            = data.cloudfoundry_space.space.id
#   service_plan     = data.cloudfoundry_service.rds.service_plans[var.rds_plan_name]
#   recursive_delete = var.recursive_delete
# }
