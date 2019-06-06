resource "aws_codebuild_project" "build" {
  name  = "build-${lookup(var.settings[count.index], "name")}"
  count = "${length(var.settings)}"

  source {
    type                = "GITHUB"
    location            = "https://github.com/${lookup(var.settings[count.index], "git_owner")}/${lookup(var.settings[count.index], "git_repo")}.git"
    git_clone_depth     = 1
    report_build_status = true
    insecure_ssl        = false
    auth {
      type = "OAUTH"
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:2.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
  }

  service_role  = "${var.build_role_arn}"
  build_timeout = "${lookup(var.settings[count.index], "build_timeout", "5")}"


  tags = {
    environment = "${var.environment}"
    project     = "${var.project}"
    owner       = "${var.owner}"
  }
}

resource "aws_codebuild_webhook" "build" {
  count        = "${length(var.settings)}"
  project_name = "build-${lookup(var.settings[count.index], "name")}"
  depends_on   = ["aws_codebuild_project.build"]
}


resource "aws_codebuild_project" "deploy" {
  name  = "deploy-${lookup(var.settings[count.index], "name")}"
  count = "${length(var.settings)}"

  source {
    type         = "CODEPIPELINE"
    buildspec    = "version: 0.2\n\n#env:\n  #variables:\n     # key: \"value\"\n     # key: \"value\"\n  #parameter-store:\n     # key: \"value\"\n     # key: \"value\"\n  #git-credential-helper: yes\n\nphases:\n  install:\n    runtime-versions:\n       nodejs: 10\n    commands:\n       - npm install\n  #pre_build:\n    #commands:\n      # - command\n      # - command\n  build:\n    commands:\n       - npm run deploy\n      # - command\n  #post_build:\n    #commands:\n      # - command\n      # - command\n#artifacts:\n  #files:\n    # - location\n    # - location\n  #name: $(date +%Y-%m-%d)\n  #discard-paths: yes\n  #base-directory: location\n#cache:\n  #paths:\n    # - paths"
    insecure_ssl = false
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:2.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_REGION"
      value = "${var.region}"
    }
  }

  service_role  = "${var.deploy_role_arn}"
  build_timeout = "${lookup(var.settings[count.index], "build_timeout", "5")}"



  tags = {
    environment = "${var.environment}"
    project     = "${var.project}"
    owner       = "${var.owner}"
  }
}
