resource "aws_s3_bucket" "deploy" {
  bucket = "${var.bucket_deployment}"
  acl    = "private"
  region = "${var.region}"

  force_destroy = true

  tags = {
    environment = "${var.environment}"
    project     = "${var.project}"
    owner       = "${var.owner}"
  }
}

resource "aws_s3_bucket_public_access_block" "deploy" {
  bucket = "${aws_s3_bucket.deploy.id}"

  block_public_acls   = true
  block_public_policy = true
}
