variable "cf_password" {}
variable "cf_user" {}

variable "aws_region" {
  type        = string
  description = "region output by cloud foundry service-key command"
  default     = "us-gov-east-1"
}

variable "cf_api_url" {
  type        = string
  description = "cloud.gov api url"
  default     = "https://api.fr.ea.cloud.gov"
}
