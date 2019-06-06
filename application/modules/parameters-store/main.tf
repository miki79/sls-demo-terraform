resource "aws_ssm_parameter" "bucket_deployment" {
  name        = "/${var.environment}/deploymentBucket"
  description = "S3 Bucket deployment"
  type        = "String"
  value       = "${var.bucket_deployment}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "app_domain" {
  name        = "/${var.environment}/domain"
  description = "APP domain"
  type        = "String"
  value       = "${var.app_domain}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "api_private_key" {
  name        = "/${var.environment}/apiPrivateKey"
  description = "API private key"
  type        = "SecureString"
  value       = "${var.api_private_key}"

  tags = {
    environment = "${var.environment}"
  }
}
