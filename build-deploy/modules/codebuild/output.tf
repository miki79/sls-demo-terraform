output "name" {
  value = ["${aws_codebuild_project.build.*.name}"]
}
