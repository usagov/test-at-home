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
}

variable "cf_space_name" {
  type        = string
  description = "cloud.gov space name (tah-<env>)"
}

variable "env" {
  type        = string
  description = "deployment environment in shortened form (stage, prod)"
}

variable "recursive_delete" {
  type        = bool
  description = "when true, deletes service bindings attached to the resource (not recommended for production)"
  default     = false
}

variable "cdn_plan_name" {
  type        = string
  description = "name of the service plan name to create"
  default     = "domain"
}

variable "global_domain_name" {
  type        = string
  description = "DNS name users will be accessing site"
}

variable "origin_domain_name" {
  type        = string
  description = "DNS name directing traffic from to each region"
}

variable "regional_domain_name" {
  type        = string
  description = "DNS name splitting traffic among a single region"
}

variable "foundation_domain_name" {
  type        = string
  description = "routable DNS name for this foundation"
}
