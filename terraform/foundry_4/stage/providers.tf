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
    bucket  = "cg-f6858d77-30ab-4017-a0d0-1ce0f2929458"
    key     = "terraform.tfstate.stage"
    encrypt = "true"
    region  = "us-gov-east-1"
    profile = "tah-foundry-4-backend"
  }
}
