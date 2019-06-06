
## READ THIS to setup OAuth for github
## https://www.itonaut.com/2018/06/18/use-github-source-in-aws-codebuild-project-using-aws-cloudformation/

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.codepipeline_bucket}"
  acl    = "private"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket" {
  bucket = "${aws_s3_bucket.codepipeline_bucket.id}"

  block_public_acls   = true
  block_public_policy = true
}

module "role" {
  source                  = "./modules/service-roles"
  project                 = "${var.project}"
  environment             = "${var.environment}"
  owner                   = "${var.owner}"
  region                  = "${var.region}"
  account_id              = "${data.aws_caller_identity.current.account_id}"
  codepipeline_bucket_arn = "${aws_s3_bucket.codepipeline_bucket.arn}"
}


module "build_project" {

  source = "./modules/codebuild"

  settings        = "${var.build_projects}"
  build_role_arn  = "${module.role.build_arn}"
  deploy_role_arn = "${module.role.deploy_arn}"
  region          = "${var.region}"

  project     = "${var.project}"
  environment = "${var.environment}"
  owner       = "${var.owner}"
}

module "pipeline_project" {
  source = "./modules/codepipeline"

  settings            = "${var.build_projects}"
  codepipeline_bucket = "${var.codepipeline_bucket}"
  codepipeline_role   = "${module.role.pipeline_arn}"
  build_projects      = "${module.build_project.name}"

}
