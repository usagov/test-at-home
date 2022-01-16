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
    bucket  = "cg-6e44ba70-f4b8-40be-a23c-1a8042250bdb"
    key     = "terraform.tfstate.prod"
    encrypt = "true"
    region  = "us-gov-west-1"
    profile = "tah-foundry-1-backend"
  }
}
