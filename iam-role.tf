# /*---------------------------------------------------------------------------------------
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
# ---------------------------------------------------------------------------------------*/

# #################################################
# # Retrieve "lz-SSMProfilePolicy-ap-southeast-3" #
# #################################################
# data "aws_iam_policy" "lz_ssm_profile" {
#   name = "lz-SSMProfilePolicy-ap-southeast-3"
# }

# #########################
# # 1 IAM Role for Cluster
# #########################

# resource "aws_iam_role" "eks_cluster_role" {
#   name = "${var.account_name}-${var.environment}-eks-cluster-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }


# resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# # Optionally, enable Security Groups for Pods
# # Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
# resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKS_CNI_Policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_cluster_role.name
# }




# ######################
# # Create Inline Policy - Put Metric Data
# ######################
# resource "aws_iam_policy" "eks_cluster_cloudwatchmetric_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-cluster-cloudwatchmetric-policy"
#   path        = "/"
#   description = "Policy to control Put Metric Data"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "cloudwatch:PutMetricData"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_cloudwatchmetric_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_cluster_cloudwatchmetric_policy.arn
#   role       = aws_iam_role.eks_cluster_role.name
# }



# ######################
# # Create Inline Policy - Read ELB
# ######################
# resource "aws_iam_policy" "eks_cluster_elb_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-cluster-elb-policy"
#   path        = "/"
#   description = "Policy to control Read ELB"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "ec2:DescribeAccountAttributes",
#                 "ec2:DescribeAddresses",
#                 "ec2:DescribeInternetGateways"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_elb_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_cluster_elb_policy.arn
#   role       = aws_iam_role.eks_cluster_role.name
# }

# ##########################
# # 2 IAM Role for Node Groups
# ##########################

resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.account_name}-${var.environment}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# resource "aws_iam_role_policy_attachment" "eks_ng_AmazonEKSVPCResourceController_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_AmazonEC2ContainerRegistryPowerUser_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_CloudWatchAgentServerPolicy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_AmazonEKSWorkerNodePolicy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_node_group_role.name
# }

resource "aws_iam_role_policy_attachment" "eks_ng_AmazonEKS_CNI_Policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

# resource "aws_iam_role_policy_attachment" "eks_ng_AmazonEC2ContainerRegistryReadOnly_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_AmazonSSMManagedInstanceCore_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# #######################
# # Create Policy - To push logs to S3 bucket using FluentBit
# #######################
# resource "aws_iam_policy" "eks_ng_push_logs_to_s3_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-ng-push-logs-to-s3-policy"
#   path        = "/"
#   description = "Policy to send logs to S3 bucket"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetObject",
#                 "kms:GenerateDataKey",
#                 "kms:Encrypt",
#                 "kms:Decrypt"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "s3:PutObjectAcl",
#                 "s3:PutObjectVersionAcl",
#                 "s3:PutObject"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::lz-ssmlog-981503552646-ap-southeast-3",
#                 "arn:aws:s3:::lz-ssmlog-981503552646-ap-southeast-3/*"
#             ],
#             "Effect": "Allow",
#             "Sid": "S3BucketAccessForSessionManager"
#         },
#         {
#             "Action": [
#                 "s3:GetEncryptionConfiguration"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::lz-ssmlog-981503552646-ap-southeast-3"
#             ],
#             "Effect": "Allow",
#             "Sid": "S3EncryptionForSessionManager"
#         },
#         {
#             "Action": [
#                 "logs:PutLogEvents",
#                 "logs:CreateLogStream",
#                 "logs:DescribeLogGroups",
#                 "logs:DescribeLogStreams"
#             ],
#             "Resource": [
#                 "*"
#             ],
#             "Effect": "Allow",
#             "Sid": "CloudWatchLogsAccessForSessionManager"
#         },
#         {
#             "Action": [
#                 "kms:Encrypt",
#                 "kms:Decrypt",
#                 "kms:ReEncrypt*",
#                 "kms:GenerateDataKey*",
#                 "kms:DescribeKeykms"
#             ],
#             "Resource": [
#                 "arn:aws:kms:ap-southeast-3:981503552646:key/6f5959d7-a855-4135-8c6d-c6949033bad5"
#             ],
#             "Effect": "Allow",
#             "Sid": "KMSEncryptionForSessionManager"
#         },
#         {
#             "Action": [
#                 "ec2:DescribeTags"
#             ],
#             "Resource": [
#                 "*"
#             ],
#             "Effect": "Allow",
#             "Sid": "EC2Basic"
#         }
#       ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "eks_ng_push_logs_to_s3_policy_attachment" {
#   policy_arn = aws_iam_policy.eks_ng_push_logs_to_s3_policy.arn
#   role       = aws_iam_role.eks_node_group_role.name
# } 

# # #######################
# # # Create Inline Policy - App Mesh to Node Group
# # #######################
# # resource "aws_iam_policy" "eks_ng_appmesh_xray_policy" {
# #   name        = "${var.account_name}-eks-ng-appmesh-xray-policy"
# #   path        = "/"
# #   description = "Policy to control App Mesh"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Action": [
# #                 "servicediscovery:CreateService",
# #                 "servicediscovery:DeleteService",
# #                 "servicediscovery:GetService",
# #                 "servicediscovery:GetInstance",
# #                 "servicediscovery:RegisterInstance",
# #                 "servicediscovery:DeregisterInstance",
# #                 "servicediscovery:ListInstances",
# #                 "servicediscovery:ListNamespaces",
# #                 "servicediscovery:ListServices",
# #                 "servicediscovery:GetInstancesHealthStatus",
# #                 "servicediscovery:UpdateInstanceCustomHealthStatus",
# #                 "servicediscovery:GetOperation",
# #                 "route53:GetHealthCheck",
# #                 "route53:CreateHealthCheck",
# #                 "route53:UpdateHealthCheck",
# #                 "route53:ChangeResourceRecordSets",
# #                 "route53:DeleteHealthCheck",
# #                 "appmesh:*"
# #             ],
# #             "Resource": "*",
# #             "Effect": "Allow"
# #         },
# #         {
# #             "Action": [
# #                 "xray:PutTraceSegments",
# #                 "xray:PutTelemetryRecords",
# #                 "xray:GetSamplingRules",
# #                 "xray:GetSamplingTargets",
# #                 "xray:GetSamplingStatisticSummaries"
# #             ],
# #             "Resource": "*",
# #             "Effect": "Allow"
# #         }
# #       ]
# #   })
# # }

# # resource "aws_iam_role_policy_attachment" "eks_ng_appmesh_xray_policy_attachments" {
# #   policy_arn = aws_iam_policy.eks_ng_appmesh_xray_policy.arn
# #   role       = aws_iam_role.eks_node_group_role.name
# # }


# #######################
# # Create Inline Policy - AUto Scaling to Node Group
# #######################
# resource "aws_iam_policy" "eks_ng_autoscaling_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-ng-autoscaling-policy"
#   path        = "/"
#   description = "Policy to control Auto Scaling"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "autoscaling:DescribeAutoScalingGroups",
#                 "autoscaling:DescribeAutoScalingInstances",
#                 "autoscaling:DescribeInstances",
#                 "autoscaling:DescribeLaunchConfigurations",
#                 "autoscaling:DescribeTags",
#                 "autoscaling:SetDesiredCapacity",
#                 "autoscaling:TerminateInstanceInAutoScalingGroup",
#                 "ec2:DescribeLaunchTemplateVersions",
#                 "ec2:DescribeInstanceTypes"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_autoscaling_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_ng_autoscaling_policy.arn
#   role       = aws_iam_role.eks_node_group_role.name
# }


# #######################
# # Create Inline Policy - AWS Load Balancer to Node Group
# #######################
# resource "aws_iam_policy" "eks_ng_awsloadbalancer_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-ng-awsloadbalancer-policy"
#   path        = "/"
#   description = "Policy to control AWS Load Balancer and Auto Scaling"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Condition": {
#                 "StringEquals": {
#                     "ec2:CreateAction": "CreateSecurityGroup"
#                 },
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             },
#             "Action": [
#                 "ec2:CreateTags"
#             ],
#             "Resource": "arn:aws:ec2:*:*:security-group/*",
#             "Effect": "Allow"
#         },
#         {
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             },
#             "Action": [
#                 "ec2:CreateTags",
#                 "ec2:DeleteTags"
#             ],
#             "Resource": "arn:aws:ec2:*:*:security-group/*",
#             "Effect": "Allow"
#         },
#         {
#             "Condition": {
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             },
#             "Action": [
#                 "elasticloadbalancing:CreateLoadBalancer",
#                 "elasticloadbalancing:CreateTargetGroup"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             },
#             "Action": [
#                 "elasticloadbalancing:AddTags",
#                 "elasticloadbalancing:RemoveTags"
#             ],
#             "Resource": [
#                 "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#             ],
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "elasticloadbalancing:AddTags",
#                 "elasticloadbalancing:RemoveTags"
#             ],
#             "Resource": [
#                 "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#             ],
#             "Effect": "Allow"
#         },
#         {
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             },
#             "Action": [
#                 "ec2:AuthorizeSecurityGroupIngress",
#                 "ec2:RevokeSecurityGroupIngress",
#                 "ec2:DeleteSecurityGroup",
#                 "elasticloadbalancing:ModifyLoadBalancerAttributes",
#                 "elasticloadbalancing:SetIpAddressType",
#                 "elasticloadbalancing:SetSecurityGroups",
#                 "elasticloadbalancing:SetSubnets",
#                 "elasticloadbalancing:DeleteLoadBalancer",
#                 "elasticloadbalancing:ModifyTargetGroup",
#                 "elasticloadbalancing:ModifyTargetGroupAttributes",
#                 "elasticloadbalancing:DeleteTargetGroup"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "elasticloadbalancing:RegisterTargets",
#                 "elasticloadbalancing:DeregisterTargets"
#             ],
#             "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#             "Effect": "Allow"
#         },
#         {
#             "Action": [
#                 "iam:CreateServiceLinkedRole",
#                 "ec2:DescribeAccountAttributes",
#                 "ec2:DescribeAddresses",
#                 "ec2:DescribeAvailabilityZones",
#                 "ec2:DescribeInternetGateways",
#                 "ec2:DescribeVpcs",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeInstances",
#                 "ec2:DescribeNetworkInterfaces",
#                 "ec2:DescribeTags",
#                 "elasticloadbalancing:DescribeLoadBalancers",
#                 "elasticloadbalancing:DescribeLoadBalancerAttributes",
#                 "elasticloadbalancing:DescribeListeners",
#                 "elasticloadbalancing:DescribeListenerCertificates",
#                 "elasticloadbalancing:DescribeSSLPolicies",
#                 "elasticloadbalancing:DescribeRules",
#                 "elasticloadbalancing:DescribeTargetGroups",
#                 "elasticloadbalancing:DescribeTargetGroupAttributes",
#                 "elasticloadbalancing:DescribeTargetHealth",
#                 "elasticloadbalancing:DescribeTags",
#                 "cognito-idp:DescribeUserPoolClient",
#                 "acm:ListCertificates",
#                 "acm:DescribeCertificate",
#                 "iam:ListServerCertificates",
#                 "iam:GetServerCertificate",
#                 "waf-regional:GetWebACL",
#                 "waf-regional:GetWebACLForResource",
#                 "waf-regional:AssociateWebACL",
#                 "waf-regional:DisassociateWebACL",
#                 "wafv2:GetWebACL",
#                 "wafv2:GetWebACLForResource",
#                 "wafv2:AssociateWebACL",
#                 "wafv2:DisassociateWebACL",
#                 "shield:GetSubscriptionState",
#                 "shield:DescribeProtection",
#                 "shield:CreateProtection",
#                 "shield:DeleteProtection",
#                 "ec2:AuthorizeSecurityGroupIngress",
#                 "ec2:RevokeSecurityGroupIngress",
#                 "ec2:CreateSecurityGroup",
#                 "elasticloadbalancing:CreateListener",
#                 "elasticloadbalancing:DeleteListener",
#                 "elasticloadbalancing:CreateRule",
#                 "elasticloadbalancing:DeleteRule",
#                 "elasticloadbalancing:SetWebAcl",
#                 "elasticloadbalancing:ModifyListener",
#                 "elasticloadbalancing:AddListenerCertificates",
#                 "elasticloadbalancing:RemoveListenerCertificates",
#                 "elasticloadbalancing:ModifyRule"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_ng_awsloadbalancer_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_ng_awsloadbalancer_policy.arn
#   role       = aws_iam_role.eks_node_group_role.name
# }

# #######################
# # Create Inline Policy - External DNS Change Set
# #######################
# # # Comment out because limitation of number of policy per role.
# # resource "aws_iam_policy" "eks_ng_externaldnschangeset_policy" {
# #   name        = "${var.account_name}-eks-ng-externaldnschangeset-policy"
# #   path        = "/"
# #   description = "Policy to control External DNS Change Set"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Action": [
# #                 "route53:ChangeResourceRecordSets"
# #             ],
# #             "Resource": "arn:aws:route53:::hostedzone/*",
# #             "Effect": "Allow"
# #         }
# #     ]
# #   })
# # }

# # resource "aws_iam_role_policy_attachment" "eks_ng_externaldnschangeset_policy_attachments" {
# #   policy_arn = aws_iam_policy.eks_ng_externaldnschangeset_policy.arn
# #   role       = aws_iam_role.eks_node_group_role.name
# # }

# #######################
# # Create Inline Policy - External DNS Hosted Zone to Node Group
# #######################
# # resource "aws_iam_policy" "eks_ng_externaldnshostedzones_policy" {
# #   name        = "${var.account_name}-${var.environment}-eks-ng-externaldnshostedzones-policy"
# #   path        = "/"
# #   description = "Policy to control External DNS Hosted Zone"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Action": [
# #                 "route53:ChangeResourceRecordSets",
# #                 "route53:ListHostedZones",
# #                 "route53:ListResourceRecordSets",
# #                 "route53:ListTagsForResource"
# #             ],
# #             "Resource": "*",
# #             "Effect": "Allow"
# #         }
# #     ]
# #   })
# # }

# # resource "aws_iam_role_policy_attachment" "eks_ng_externaldnshostedzones_policy_attachments" {
# #   policy_arn = aws_iam_policy.eks_ng_externaldnshostedzones_policy.arn
# #   role       = aws_iam_role.eks_node_group_role.name
# # }

# #######################
# # Create Inline Policy - Xray
# #######################
# # # Commented due to limtation of number of policy for role
# # resource "aws_iam_policy" "eks_ng_xray_policy" {
# #   name        = "${var.account_name}-eks-ng-xray-policy"
# #   path        = "/"
# #   description = "Policy to control Xray"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Action": [
# #                 "xray:PutTraceSegments",
# #                 "xray:PutTelemetryRecords",
# #                 "xray:GetSamplingRules",
# #                 "xray:GetSamplingTargets",
# #                 "xray:GetSamplingStatisticSummaries"
# #             ],
# #             "Resource": "*",
# #             "Effect": "Allow"
# #         }
# #     ]
# #   })
# # }

# # resource "aws_iam_role_policy_attachment" "eks_ng_xray_policy_attachments" {
# #   policy_arn = aws_iam_policy.eks_ng_xray_policy.arn
# #   role       = aws_iam_role.eks_node_group_role.name
# # }


# ###################################################################################
# # Create Policy for ALB Ingress COntroller: Name: ALBIngressControllerIAMPolicy (alb-ingress-controller-policy)
# ###################################################################################
# resource "aws_iam_policy" "alb_ingress_controller_policy" {
#   name        = "${var.account_name}-${var.environment}-alb-ingress-controller-policy"
#   path        = "/"
#   description = "Policy to control Ingress Policy and to be attached to EKS Service Account"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "acm:DescribeCertificate",
#           "acm:ListCertificates",
#           "acm:GetCertificate"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:AuthorizeSecurityGroupIngress",
#           "ec2:CreateSecurityGroup",
#           "ec2:CreateTags",
#           "ec2:DeleteTags",
#           "ec2:DeleteSecurityGroup",
#           "ec2:DescribeAccountAttributes",
#           "ec2:DescribeAddresses",
#           "ec2:DescribeInstances",
#           "ec2:DescribeInstanceStatus",
#           "ec2:DescribeInternetGateways",
#           "ec2:DescribeNetworkInterfaces",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeTags",
#           "ec2:DescribeVpcs",
#           "ec2:ModifyInstanceAttribute",
#           "ec2:ModifyNetworkInterfaceAttribute",
#           "ec2:RevokeSecurityGroupIngress"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "elasticloadbalancing:AddListenerCertificates",
#           "elasticloadbalancing:AddTags",
#           "elasticloadbalancing:CreateListener",
#           "elasticloadbalancing:CreateLoadBalancer",
#           "elasticloadbalancing:CreateRule",
#           "elasticloadbalancing:CreateTargetGroup",
#           "elasticloadbalancing:DeleteListener",
#           "elasticloadbalancing:DeleteLoadBalancer",
#           "elasticloadbalancing:DeleteRule",
#           "elasticloadbalancing:DeleteTargetGroup",
#           "elasticloadbalancing:DeregisterTargets",
#           "elasticloadbalancing:DescribeListenerCertificates",
#           "elasticloadbalancing:DescribeListeners",
#           "elasticloadbalancing:DescribeLoadBalancers",
#           "elasticloadbalancing:DescribeLoadBalancerAttributes",
#           "elasticloadbalancing:DescribeRules",
#           "elasticloadbalancing:DescribeSSLPolicies",
#           "elasticloadbalancing:DescribeTags",
#           "elasticloadbalancing:DescribeTargetGroups",
#           "elasticloadbalancing:DescribeTargetGroupAttributes",
#           "elasticloadbalancing:DescribeTargetHealth",
#           "elasticloadbalancing:ModifyListener",
#           "elasticloadbalancing:ModifyLoadBalancerAttributes",
#           "elasticloadbalancing:ModifyRule",
#           "elasticloadbalancing:ModifyTargetGroup",
#           "elasticloadbalancing:ModifyTargetGroupAttributes",
#           "elasticloadbalancing:RegisterTargets",
#           "elasticloadbalancing:RemoveListenerCertificates",
#           "elasticloadbalancing:RemoveTags",
#           "elasticloadbalancing:SetIpAddressType",
#           "elasticloadbalancing:SetSecurityGroups",
#           "elasticloadbalancing:SetSubnets",
#           "elasticloadbalancing:SetWebACL"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "iam:CreateServiceLinkedRole",
#           "iam:GetServerCertificate",
#           "iam:ListServerCertificates"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "cognito-idp:DescribeUserPoolClient"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "waf-regional:GetWebACLForResource",
#           "waf-regional:GetWebACL",
#           "waf-regional:AssociateWebACL",
#           "waf-regional:DisassociateWebACL"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "tag:GetResources",
#           "tag:TagResources"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "waf:GetWebACL"
#         ],
#         "Resource": "*"
#       }
#     ]
#   })
# }

# ###################################################################################
# # Instance Profile for Self Managed Node Group
# ###################################################################################
# resource "aws_iam_instance_profile" "eks_node_group_instance_profile" {
#   name = "${var.account_name}-instance-profile"
#   role = aws_iam_role.eks_node_group_role.name
# }


# ###################################################################################
# # IAM Policy to retrieve value from SSM Parameter Store
# ###################################################################################
# resource "aws_iam_policy" "retrieve_ssm_param_policy" {
#   name        = "${var.account_name}-${var.environment}-retrieve-ssm-param-policy"
#   path        = "/"
#   description = "Policy to retrieve SSM Parameter Store"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode(
#     {
#       "Version": "2012-10-17",
#       "Statement": [ {
#           "Effect": "Allow",
#           "Action": ["ssm:Get*", "ssm:List*","ssm:Describe*"],
#           # "Action": ["ssm:GetParameter", "ssm:GetParameters"],
#           "Resource": "*"
#           # ["arn:aws:ssm:${var.region}:${var.account_number}:/account/*"]
#       } ]
#     })
# }


# ###########################################
# #Role For Cluster Admin
# ###########################################

# resource "aws_iam_role" "eks_cluster_admin_role" {
#   name = "${var.account_name}-${var.environment}-eks-cluster-admin-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   # assume_role_policy = jsonencode({
#   #   Version = "2012-10-17"
#   #   Statement = [
#   #     {
#   #       Action = "sts:AssumeRole"
#   #       Effect = "Allow"
#   #       Sid    = ""
#   #       Principal = {
#   #         AWS = "${aws_iam_user.k8s_administrator_user.arn}"
#   #       }
#   #     },
#   #   ]
#   # })

#     assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "arn:aws:iam::${var.account_number}:root"
#         }
#       },
#     ]
#   })

#   tags = {
#     Name      = "${var.account_name}-eks-cluster-admin-role"
#     Namespace = "kube-system"
#   }
# }

# # Create ECR-PowerUser Policy
# resource "aws_iam_policy" "ecr_poweruser_policy" {
#   name        = "${var.account_name}-${var.environment}-ecr-power-user-policy"
#   path        = "/"
#   description = "Policy to control ECR access"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecr:GetAuthorizationToken",
#                 "sts:GetServiceBearerToken",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:DescribeRepositories",
#                 "ecr:DescribeRegistries",
#                 "ecr:DescribeImages",
#                 "ecr:DescribeImageTags",
#                 "ecr:GetRepositoryCatalogData",
#                 "ecr:GetRegistryCatalogData",
#                 "ecr:InitiateLayerUpload",
#                 "ecr:UploadLayerPart",
#                 "ecr:CompleteLayerUpload",
#                 "ecr:PutImage",
#                 "ecr:BatchGetImage",
#                 "ecr:GetDownloadForLayer",
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:CreateRepository"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# # Create EKS Admin Policy
# resource "aws_iam_policy" "eks_admin_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-admin-policy"
#   path        = "/"
#   description = "Policy to control EKS access"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": "eks:*",
#             "Resource": "*"
#         }
#     ]
#   })
# }

# # Create set desire autoscaling Policy
# resource "aws_iam_policy" "set_desire_autoscaling_policy" {
#   name        = "${var.account_name}-${var.environment}-set-desire-autoscaling-policy"
#   path        = "/"
#   description = "Policy to control set-desire-autoscaling"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "autoscaling:DescribeScalingActivities",
#                 "autoscaling:SetDesiredCapacity",
#                 "autoscaling:DescribeAutoScalingGroups",
#                 "autoscaling:StartInstanceRefresh",
#                 "autoscaling:DescribeInstanceRefreshes"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# # Create Policy - SSM Document
# resource "aws_iam_policy" "ssm_full_policy" {
#   name        = "${var.account_name}-${var.environment}-ssm-full-policy"
#   path        = "/"
#   description = "Policy to control Read ELB"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "ssm:*"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#     ]
#   })
# }

# # Create Policy - SSM Document
# resource "aws_iam_policy" "codecommit_policy" {
#   name        = "${var.account_name}-${var.environment}-codecommit-policy"
#   path        = "/"
#   description = "Policy to control Read ELB"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "codecommit:CreateBranch",
#                 "codecommit:UpdateComment",
#                 "codecommit:UpdateRepositoryDescription",
#                 "codecommit:CreateRepository",
#                 "codecommit:CreateCommit",
#                 "codecommit:GetRepository"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecr_poweruser_policy_attachments" {
#   policy_arn = aws_iam_policy.ecr_poweruser_policy.arn
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_admin_policy.arn
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# resource "aws_iam_role_policy_attachment" "set_desire_autoscaling_policy_attachments" {
#   policy_arn = aws_iam_policy.set_desire_autoscaling_policy.arn
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# resource "aws_iam_role_policy_attachment" "s3_bucket_policy_attachments" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# resource "aws_iam_role_policy_attachment" "ssm_full_policy_attachments" {
#   policy_arn = aws_iam_policy.ssm_full_policy.arn
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# resource "aws_iam_role_policy_attachment" "codecommit_policy_attachments" {
#   policy_arn = aws_iam_policy.codecommit_policy.arn
#   role       = aws_iam_role.eks_cluster_admin_role.name
# }

# ###########################################################
# ######### RBAC Setup for EKS Cluster & Namespace ##########
# ###########################################################

# #######################
# # Create Policy - To Read & List EKS
# #######################
# resource "aws_iam_policy" "eks_read_list_policy" {
#   name        = "${var.account_name}-${var.environment}-eks-read-list-policy"
#   path        = "/"
#   description = "Policy to read and list EKS"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "eks:ListNodegroups",
#                 "eks:DescribeFargateProfile",
#                 "eks:ListTagsForResource",
#                 "eks:ListAddons",
#                 "eks:DescribeAddon",
#                 "eks:ListFargateProfiles",
#                 "eks:DescribeNodegroup",
#                 "eks:DescribeIdentityProviderConfig",
#                 "eks:ListUpdates",
#                 "eks:DescribeUpdate",
#                 "eks:AccessKubernetesApi",
#                 "eks:DescribeCluster",
#                 "eks:ListClusters",
#                 "eks:DescribeAddonVersions",
#                 "eks:ListIdentityProviderConfigs"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# ############################################
# # Role For Consul Access
# ############################################

# resource "aws_iam_role" "consul-full-access-role" {
#  name = "${var.account_name}-${var.environment}-consul-full-access-role"
 
#  # Terraform's "jsonencode" function converts a
#  # Terraform expression result to valid JSON syntax.
#  assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid = ""
#         Principal = {
#           AWS = "arn:aws:iam::${var.account_number}:root"
#         }
#       },
#     ]
#  })
 
#  tags = {
#  Name = "${var.account_name}-consul-full-access-role"
#  Namespace = "consul-system"
#  }
# }


# resource "aws_iam_role_policy_attachment" "eks_readlist_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_read_list_policy.arn
#   role       = aws_iam_role.consul-full-access-role.name
# }

# ############################################
# # Role For webapi Apps
# ############################################
# resource "aws_iam_role" "eks_webapi_apps_role" {
#   name = "${var.account_name}-${var.environment}-eks-webapi-apps-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "arn:aws:iam::${var.account_number}:root"
#         }
#       },
#     ]
#   })

#   tags = {
#     Namespace = "webapi"
#   }
# }

# resource "aws_iam_role_policy_attachment" "eks_webapi_readlist_policy_attachments" {
#   policy_arn = aws_iam_policy.eks_read_list_policy.arn
#   role       = aws_iam_role.eks_webapi_apps_role.name
# }

# # ############################################
# # # Role For wcms Apps
# # ############################################
# resource "aws_iam_role" "eks_wcms_apps_role" {
#   name = "${var.account_name}-${var.environment}-eks-wcms-apps-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "${aws_iam_user.k8s_wcms_admin_user.arn}"
#         }
#       },
#     ]
#   })

#   tags = {
#     Namespace = "wcms"
#   }
# }

# ############################################
# # Role For Read EKS - web-api
# ############################################
# resource "aws_iam_role" "read_webapi_apps_role" {
#   name = "${var.account_name}-${var.environment}-eks-read-webapi-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "arn:aws:iam::${var.account_number}:root"
#         }
#       },
#     ]
#   })

#   tags = {
#     Namespace = "webapi"
#   }
# }

# ###########################################
# #Role For SSM Automation =- TESTING
# ###########################################

# resource "aws_iam_role" "ssm_automation_role" {
#   name = "${var.account_name}-${var.environment}-ssm-automation-role"

#     assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ssm.amazonaws.com"
#         }
#         Condition= {
#           StringEquals= {
#             "aws:SourceAccount"= "${var.account_number}"
#           },
#           ArnLike= {
#             "aws:SourceArn"= "arn:aws:ssm:${var.region}:${var.account_number}:*"
#           },
#         }
#       },
#     ]
#   })

#   tags = {
#     Name      = "${var.account_name}-ssm-automation"
#   }
# }


# ########################################
# # Role for External DNS
# ########################################
# resource "aws_iam_policy" "ext_dns_policy" {
#   name        = "${var.account_name}-${var.environment}-ext-dns-policy"
#   path        = "/"
#   description = "Policy to external dns"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "route53:ChangeResourceRecordSets"
#         ],
#         "Resource": [
#           "arn:aws:route53:::hostedzone/*"
#         ]
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "route53:ListHostedZones",
#           "route53:ListResourceRecordSets"
#         ],
#         "Resource": [
#           "*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "ext_dns_role" {
#     name = "${var.account_name}-${var.environment}-ext-dns-role"
#     assume_role_policy = jsonencode({
#                "Statement":[
#                   {
#                      "Action":[
#                         "sts:AssumeRoleWithWebIdentity"
#                      ],
#                      "Condition":{
#                         "StringEquals":{
#                            "${module.eks_cluster.oidc_provider}:aud":"sts.amazonaws.com",
#                            "${module.eks_cluster.oidc_provider}:sub":var.ext_dns_role_sa,
#                         }
#                      },
#                      "Effect":"Allow",
#                      "Principal":{
#                         "Federated":"${module.eks_cluster.oidc_provider_arn}"
#                      }
#                   }
#                ],
#                "Version":"2012-10-17"
#             })
# }

# resource "aws_iam_role_policy_attachment" "ext_dns_policy_attachments" {
#   policy_arn = aws_iam_policy.ext_dns_policy.arn
#   role       = aws_iam_role.ext_dns_role.name
# }

# ########################################
# # Role for SplunkExecutor
# ########################################

# resource "aws_iam_role" "splunk_executor_role" {
#   name = "${var.account_name}-${var.environment}-splunk-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "arn:aws:iam::${var.account_number}:root"
#         }
#       },
#     ]
#   })
# }

# # S3 Policy for IAM Role Splunk
# resource "aws_iam_policy" "splunk_s3_policy" {
#   name        = "${var.account_name}-${var.environment}-splunk-s3-policy"
#   path        = "/"
#   description = "Policy to get/list to S3 bucket"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "s3:List*",
#                 "s3:Get*",
#                 "kms:GenerateDataKey",
#                 "kms:Encrypt",
#                 "kms:Decrypt"
#             ],
#             "Resource": "*",
#             "Effect": "Allow"
#         }
#       ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "splunk_attachments" {
#   policy_arn = aws_iam_policy.splunk_s3_policy.arn
#   role       = aws_iam_role.splunk_executor_role.name
# }

# #######################################
# # Role for Lambda - Restart PHP-FPM   #
# #######################################

# data "aws_iam_policy" "AmazonEC2FullAccess" {
#   name = "AmazonEC2FullAccess"
# }

# data "aws_iam_policy" "AmazonSSMFullAccess" {
#   name = "AmazonSSMFullAccess"
# }

# data "aws_iam_policy" "AWSLambdaExecute" {
#   name = "AWSLambdaExecute"
# }

# # Create Role
# resource "aws_iam_role" "lambda_php_restart_role" {
#   name = "${var.account_name}-${var.environment}-lambda-php-restart-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       },
#     ]
#   })
# }


# # Policy
# resource "aws_iam_policy" "lambda_php_restart_policy" {
#   depends_on = [
    
#   ]
#   name        = "${var.account_name}-lambda-php-restart-policy"
#   path        = "/"
#   description = "Policy to run SendCommand to the SSM Document"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "logs:CreateLogGroup",
#             "Resource": "arn:aws:logs:ap-southeast-3:${var.account_number}:*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": [
#                 "arn:aws:logs:ap-southeast-3:${var.account_number}:log-group:/aws/lambda/lambda_fpm_nok:*"
#             ]
#         }
#     ]
#   })
# }

# # Attachement Policy
# resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
#   policy_arn = data.aws_iam_policy.AmazonEC2FullAccess.arn
#   role       = aws_iam_role.lambda_php_restart_role.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonSSMFullAccess" {
#   policy_arn = data.aws_iam_policy.AmazonSSMFullAccess.arn
#   role       = aws_iam_role.lambda_php_restart_role.name
# }

# resource "aws_iam_role_policy_attachment" "AWSLambdaExecute" {
#   policy_arn = data.aws_iam_policy.AWSLambdaExecute.arn
#   role       = aws_iam_role.lambda_php_restart_role.name
# }

# resource "aws_iam_role_policy_attachment" "lambda_php_restart_attachments" {
#   policy_arn = aws_iam_policy.lambda_php_restart_policy.arn
#   role       = aws_iam_role.lambda_php_restart_role.name
# }

# ########################################################
# # IAM Role for Lambda Scale In/Out to Region - Outpost #
# ########################################################

# resource "aws_iam_policy" "access_to_scale_inout" {
#   name        = "${var.account_name}-${var.environment}-access-to-scale-inout-policy"
#   path        = "/"
#   description = "Policy to scale in/out to region"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = <<EOT
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:DescribeInstances",
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents",
#                 "logs:DescribeLogStreams",
#                 "autoscaling:SetDesiredCapacity",
#                 "autoscaling:DescribeLoadBalancerTargetGroups",
#                 "route53:ChangeResourceRecordSets",
#                 "route53:ListResourceRecordSets"
#             ],
#             "Resource": [
#                 "arn:aws:autoscaling::${var.account_number}:autoScalingGroup::autoScalingGroupName/*",
#                 "arn:aws:route53:::hostedzone/*",
#                 "*"
#             ]
#         },
#         {
#             "Action": [
#                 "elasticloadbalancing:RegisterTargets",
#                 "elasticloadbalancing:DeregisterTargets",
#                 "elasticloadbalancing:Describe*",
#                 "elasticloadbalancing:*"
#             ],
#             "Effect": "Allow",
#             "Resource": [
#                 "*"
#             ],
#             "Sid": "thesesectionforlbpermission"
#         }
#     ]
# }
# EOT
# }

# resource "aws_iam_policy" "auto_register_policy" {
#   name        = "${var.account_name}-${var.environment}-auto-register-policy"
#   path        = "/"
#   description = "Policy to autoregister tg to region"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = <<EOT
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "elasticloadbalancing:ModifyListener",
#                 "autoscaling:SetDesiredCapacity",
#                 "autoscaling:DescribeLoadBalancerTargetGroups",
#                 "elasticloadbalancing:ModifyRule"
#             ],
#             "Effect": "Allow",
#             "Resource": [
#                 "arn:aws:elasticloadbalancing::981503552646:listener-rule/net////*",
#                 "arn:aws:elasticloadbalancing::981503552646:listener/net///",
#                 "arn:aws:elasticloadbalancing::981503552646:listener/app///",
#                 "arn:aws:elasticloadbalancing::981503552646:listener-rule/app////*",
#                 "arn:aws:autoscaling::981503552646:autoScalingGroup::autoScalingGroupName/*"
#             ],
#             "Sid": "VisualEditor0"
#         },
#         {
#             "Action": [
#                 "elasticloadbalancing:DescribeLoadBalancers",
#                 "elasticloadbalancing:DescribeListeners",
#                 "elasticloadbalancing:DescribeTargetGroups",
#                 "elasticloadbalancing:DescribeRules",
#                 "elasticloadbalancing:DescribeTargetHealth"
#             ],
#             "Effect": "Allow",
#             "Resource": "*",
#             "Sid": "VisualEditor1"
#         }
#     ]
# }
# EOT
# }
# ##############################
# ## Create IAM Role - Outpost #
# ##############################
# resource "aws_iam_role" "lambda_iam_manage_scale_inout_role" {
#   name = "${var.account_name}-${var.environment}-lambda-iam-manage-scale-inout-role"
#   path = "/"

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "lambda.amazonaws.com",
#                 "AWS": "arn:aws:iam::779382227994:root"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "lambda_iam_manage_scale_inout_attachment" {
#   role       = aws_iam_role.lambda_iam_manage_scale_inout_role.name
#   policy_arn = aws_iam_policy.access_to_scale_inout.arn
# }

# resource "aws_iam_role_policy_attachment" "auto_register_tg_attachment" {
#   role       = aws_iam_role.lambda_iam_manage_scale_inout_role.name
#   policy_arn = aws_iam_policy.auto_register_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "ASGFullAccess_tg_attachment" {
#   role       = aws_iam_role.lambda_iam_manage_scale_inout_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "eks_admin_tg_attachment" {
#   role       = aws_iam_role.lambda_iam_manage_scale_inout_role.name
#   policy_arn = aws_iam_policy.eks_admin_policy.arn
# }



# ########################################
# # Role for EFS Attachment (Not Required)
# ########################################

# # resource "aws_iam_policy" "eks_ng_efs_csi_driver_policy" {
# #   name        = "${var.account_name}-eks-ng-efs-csi-driver-policy"
# #   path        = "/"
# #   description = "Policy to control Auto Scaling"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #       {
# #         "Effect": "Allow",
# #         "Action": [
# #           "elasticfilesystem:DescribeAccessPoints",
# #           "elasticfilesystem:DescribeFileSystems"
# #         ],
# #         "Resource": "*"
# #       },
# #       {
# #         "Effect": "Allow",
# #         "Action": [
# #           "elasticfilesystem:CreateAccessPoint"
# #         ],
# #         "Resource": "*",
# #         "Condition": {
# #           "StringLike": {
# #             "aws:RequestTag/efs.csi.aws.com/cluster": "true"
# #           }
# #         }
# #       },
# #       {
# #         "Effect": "Allow",
# #         "Action": "elasticfilesystem:DeleteAccessPoint",
# #         "Resource": "*",
# #         "Condition": {
# #           "StringEquals": {
# #             "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
# #           }
# #         }
# #       }
# #     ]
# #   })
# # }
