# Installation

When running the terraform script, setup the environmental variable "GITHUB_TOKEN" https://www.terraform.io/docs/providers/aws/r/codepipeline.html

- Setup OAuth for GitHub in codebuild https://www.itonaut.com/2018/06/18/use-github-source-in-aws-codebuild-project-using-aws-cloudformation/

## Limitations

- Maunal setup of webooks for codepipeline
- Manual setup filter for codebuild (this should be fixed soon with the new release of terraform)

## TODO

- limit permissions for deploy role
