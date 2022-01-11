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
    bucket  = "cg-fa15ed09-9879-4e56-8421-db092a5bac8f"
    key     = "terraform.tfstate.stage"
    encrypt = "true"
    region  = "us-gov-west-1"
    profile = "tah-foundry-0-backend"
  }
}
