output "build_arn" {
  value = "${aws_iam_role.build_role.arn}"
}

output "deploy_arn" {
  value = "${aws_iam_role.deploy_role.arn}"
}

output "pipeline_arn" {
  value = "${aws_iam_role.codepipeline_role.arn}"
}
