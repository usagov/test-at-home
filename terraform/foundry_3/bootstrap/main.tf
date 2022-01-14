module "s3" {
  source = "../../shared/s3"

  aws_region      = "us-gov-east-1"
  cf_api_url      = "https://api.fr.ea.cloud.gov"
  cf_user         = var.cf_user
  cf_password     = var.cf_password
  cf_org_name     = "gsa-tts-test-kits"
  cf_space_name   = "prod"
  s3_service_name = "tah-shared-config"
  s3_plan_name    = "basic"
}

output "bucket_credentials" {
  value = module.s3.bucket_credentials
}
