/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/

##########################################
#Role For Cluster Admin
###########################################

resource "aws_iam_role" "eks_cluster_admin_role" {
  name = "${var.account_name}-${var.environment}-eks-cluster-admin-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # assume_role_policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Action = "sts:AssumeRole"
  #       Effect = "Allow"
  #       Sid    = ""
  #       Principal = {
  #         AWS = "${aws_iam_user.k8s_administrator_user.arn}"
  #       }
  #     },
  #   ]
  # })

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.account_number}:root"
        }
      },
    ]
  })

  tags = {
    Name      = "${var.account_name}-eks-cluster-admin-role"
    Namespace = "kube-system"
  }
}

# Create ECR-PowerUser Policy
resource "aws_iam_policy" "ecr_poweruser_policy" {
  name        = "${var.account_name}-${var.environment}-ecr-power-user-policy"
  path        = "/"
  description = "Policy to control ECR access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "sts:GetServiceBearerToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:DescribeRegistries",
                "ecr:DescribeImages",
                "ecr:DescribeImageTags",
                "ecr:GetRepositoryCatalogData",
                "ecr:GetRegistryCatalogData",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage",
                "ecr:BatchGetImage",
                "ecr:GetDownloadForLayer",
                "ecr:GetDownloadUrlForLayer",
                "ecr:CreateRepository"
            ],
            "Resource": "*"
        }
    ]
  })
}

# Create EKS Admin Policy
resource "aws_iam_policy" "eks_admin_policy" {
  name        = "${var.account_name}-${var.environment}-eks-admin-policy"
  path        = "/"
  description = "Policy to control EKS access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
  })
}

# Create set desire autoscaling Policy
resource "aws_iam_policy" "set_desire_autoscaling_policy" {
  name        = "${var.account_name}-${var.environment}-set-desire-autoscaling-policy"
  path        = "/"
  description = "Policy to control set-desire-autoscaling"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeScalingActivities",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:StartInstanceRefresh",
                "autoscaling:DescribeInstanceRefreshes"
            ],
            "Resource": "*"
        }
    ]
  })
}
# ###############################################################
# # IAM User for FluxCD
# ###############################################################
# resource "aws_iam_user" "fluxcd_admin_user" {
#   name = "fluxcd-${var.account_name}-${var.environment}"
# }

# resource "aws_iam_user_policy" "fluxcd_policy" {
#   name = "fluxcd-policy"
#   user = aws_iam_user.fluxcd_admin_user.name

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": "codecommit:*",
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

#########################
# 1 IAM Role for Cluster
#########################

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.account_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKS_CNI_Policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role.name
}

# resource "aws_iam_service_specific_credential" "fluxcd_admin" {
#   service_name = "codecommit.amazonaws.com"
#   user_name    = aws_iam_user.fluxcd_admin_user.name
# }

# output "fluxcd_username" {
#   value = aws_iam_service_specific_credential.fluxcd_admin.service_user_name
# }

# output "fluxcd_password" {
#   value = aws_iam_service_specific_credential.fluxcd_admin.service_user_name
# }