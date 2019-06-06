variable "environment" {
  default = "dev"
}

variable "region" {
  default = "eu-west-1"
}

variable "project" {}

variable "owner" {}

variable "build_projects" {
  type = "list"
  default = [

  ]
}

variable "codepipeline_bucket" {}
