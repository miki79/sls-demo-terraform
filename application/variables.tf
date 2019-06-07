variable "region" {
  type = "string"
}

variable "route53_root_domain_name" {
  type        = "string"
  description = "Main root domain for API gateway, for example api.mydomain.com"
}
variable "route53_sub_domain_name" {
  type        = "string"
  description = "Subdomain for API gateway, the application will be exposed on this subdomain, for example documents.api.mydomain.com"
}

variable "s3_bucket_deployment" {
  type        = "string"
  description = "S3 bucket for serverless deployment"
}

variable "environment" {
  type    = "string"
  default = "dev"
}

variable "api_private_key" {
  type        = "string"
  description = "API access token"
}

variable "project" {
  type        = "string"
  description = "Name of the project"
}

variable "owner" {
  type        = "string"
  description = "Owner of the project"
}
