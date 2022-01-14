variable "aws_region" {
  type        = string
  description = "region output by cloud foundry service-key command"
}

variable "cf_api_url" {
  type        = string
  description = "cloud.gov api url"
}

variable "cf_user" {
  type        = string
  description = "cloud.gov deployer account user"
}

variable "cf_password" {
  type        = string
  description = "secret; cloud.gov deployer account password"
  sensitive   = true
}

variable "cf_org_name" {
  type        = string
  description = "cloud.gov organization name"
  default     = "tts-usps-test-at-home"
}

variable "cf_space_name" {
  type        = string
  description = "cloud.gov space name (staging or prod)"
}

variable "recursive_delete" {
  type        = bool
  description = "when true, deletes service bindings attached to the resource (not recommended for production)"
  default     = false
}

variable "s3_service_name" {
  type        = string
  description = "name for the cloud.gov managed service"
}

variable "s3_plan_name" {
  type        = string
  description = "name of the service plan to create"
}
