provider "aws" {
  region = "${var.region}"
}

module "domain" {
  source = "./modules/domain"

  route53_root_domain_name = "${var.route53_root_domain_name}"
  route53_sub_domain_name  = "${var.route53_sub_domain_name}"

  project     = "${var.project}"
  environment = "${var.environment}"
  owner       = "${var.owner}"

}

module "parameters_store" {
  source            = "./modules/parameters-store"
  bucket_deployment = "${var.s3_bucket_deployment}-${var.region}" ### TODO - fix and put reference to bucket_deployment module
  app_domain        = "${var.route53_sub_domain_name}"
  api_private_key   = "${var.api_private_key}"

  project     = "${var.project}"
  environment = "${var.environment}"
  owner       = "${var.owner}"
}

module "bucket_deployment" {
  source = "./modules/bucket"

  bucket_deployment = "${var.s3_bucket_deployment}-${var.region}"
  region            = "${var.region}"

  project     = "${var.project}"
  environment = "${var.environment}"
  owner       = "${var.owner}"
}
