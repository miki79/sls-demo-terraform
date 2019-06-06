

resource "aws_codepipeline" "codepipeline" {
  name     = "cp-${lookup(var.settings[count.index], "name")}"
  role_arn = "${var.codepipeline_role}"

  count = "${length(var.settings)}"

  artifact_store {
    location = "${var.codepipeline_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "DownloadFromGitHub"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner                = "${lookup(var.settings[count.index], "git_owner")}"
        Repo                 = "${lookup(var.settings[count.index], "git_repo")}"
        Branch               = "master"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAndTest"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "build-${lookup(var.settings[count.index], "name")}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployApplication"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ProjectName = "deploy-${lookup(var.settings[count.index], "name")}"
      }
    }
  }
}
