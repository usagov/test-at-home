terraform {
  required_version = "~> 1.0"
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.12.6"
    }
    aws = {
      version = "~> 3.11.0"
    }
  }

  backend "s3" {
    bucket  = "cg-42b05d6d-07ff-463a-90ca-374ad5e6f06a"
    key     = "terraform.tfstate.stage"
    encrypt = "true"
    region  = "us-gov-east-1"
    profile = "tah-foundry-3-backend"
  }
}

provider "cloudfoundry" {
  api_url      = local.cf_api_url
  user         = var.cf_user
  password     = var.cf_password
  app_logs_max = 30
}

provider "aws" {
  region = local.aws_region
}
