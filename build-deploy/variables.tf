variable "environment" {
  type    = "string"
  default = "dev"
}

variable "region" {
  type = "string"
}

variable "project" {
  type        = "string"
  description = "Name of the project"
}

variable "owner" {
  type        = "string"
  description = "Owner of the project"
}

# Example project
# {
#     "git_repo"      = "name-repo in GitHub",
#     "git_owner"     = "owner-repo in GitHub"
#     "name"          = "name-application",
#     "build_timeout" = "5"
# }
variable "build_projects" {
  type = "list"
  default = [
  ]
  description = "List of application to be setup with CI/CD"
}

variable "codepipeline_bucket" {
  type        = "string"
  description = "S3 bucket to be used by codepipeline"
}
