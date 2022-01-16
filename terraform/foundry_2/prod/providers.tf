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
    bucket  = "cg-f13fc659-fa22-4323-9a62-afcf33cebc50"
    key     = "terraform.tfstate.prod"
    encrypt = "true"
    region  = "us-gov-west-1"
    profile = "tah-foundry-2-backend"
  }
}
