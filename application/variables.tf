variable "region" {}

variable "route53_root_domain_name" {}
variable "route53_sub_domain_name" {}

variable "s3_bucket_deployment" {}

variable "environment" {
  type    = "string"
  default = "dev"
}

variable "api_private_key" {
  description = "API access token"
}
