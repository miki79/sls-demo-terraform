resource "aws_iam_role" "build_role" {
  name_prefix = "codebuild-${var.project}"

  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
    owner = "${var.owner}"
  }

}

resource "aws_iam_role_policy" "build_policy" {
  role = "${aws_iam_role.build_role.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/*",
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/*:*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },    
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": ["${var.codepipeline_bucket_arn}","${var.codepipeline_bucket_arn}/*"]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "codepipeline_role" {
  name_prefix = "codepipeline-${var.project}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"        
      ],
      "Resource": [
        "${var.codepipeline_bucket_arn}",
        "${var.codepipeline_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "deploy_role" {
  name_prefix = "codebuild-deploy-${var.project}"

  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    environment = "${var.environment}"
    project = "${var.project}"
    owner = "${var.owner}"
  }
}

resource "aws_iam_role_policy" "deploy_policy" {
  role = "${aws_iam_role.deploy_role.name}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:ListRoleTags",
                "iam:UntagRole",
                "iam:TagRole",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:UpdateRoleDescription",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:UpdateRole",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy"
            ],
            "Resource": "arn:aws:iam::*:role/crm-poc-dev*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "iam:ListRoles",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "deploy_policy" {
  role       = "${aws_iam_role.deploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
