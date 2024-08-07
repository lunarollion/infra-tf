/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/
locals {
  node_security_group_additional_rules = {
    ingress_webapi_app_tcp = {
      description                   = "[Additional] Allow webapi Apps to Access Node for DNS Resolution"
      protocol                      = "tcp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"
      source_security_group_id      = module.webapi_eks_pods_security_group.out_id
    }
    ingress_webapi_app_udp = {
      description                   = "[Additional] Allow webapi Apps to Access Node for DNS Resolution"
      protocol                      = "udp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"
      source_security_group_id      = module.webapi_eks_pods_security_group.out_id
    }
    ingress_wcms_app_tcp = {
      description                   = "[Additional] Allow wcms Apps to Access Node for DNS Resolution"
      protocol                      = "tcp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"
      source_security_group_id      = module.wcms_eks_pods_security_group.out_id
    }
    ingress_wcms_app_udp = {
      description                   = "[Additional] Allow wcms Apps to Access Node for DNS Resolution"
      protocol                      = "udp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"
      source_security_group_id      = module.wcms_eks_pods_security_group.out_id
    }
    ingress_all_nodes = {
      description                   = "[Additional] Nodes Inter-communications"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      self                          = true
    }
    egress_all = {
      description                   = "[Additional] Egress all to Internet"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "egress"
      cidr_blocks                   = ["0.0.0.0/0"]
    }
  }


  metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "optional"
      http_put_response_hop_limit = 1
    }
}

#############################################
### Create KMS Key for EBS
#############################################
resource "aws_kms_key" "ebs_kms" {

  description             = "KMS key for EBS - Secure Data at rest"
  enable_key_rotation     = true

  policy = <<EOT
{
   "Version":"2012-10-17",
   "Id":"${var.account_name}-ebs-policy",
   "Statement":[
      {
        "Sid":"Allow direct access to key metadata to the account",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${var.account_number}:root"
         },
         "Action":"kms:*",
         "Resource":"*"
      },
      {
         "Sid":"Allow access through EC2 for all principals in the account that are authorized to use EBS",
         "Effect":"Allow",
         "Principal":{
            "AWS": "arn:aws:iam::${var.account_number}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
         },
         "Action":[
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKeykms"
         ],
         "Resource":"*",
         "Condition":{
            "StringEquals":{
               "kms:CallerAccount":"${var.account_number}",
               "kms:ViaService":[
                  "ec2.${var.region}.amazonaws.com",
                  "autoscaling.${var.region}.amazonaws.com"
               ]
            }
         }
      },
      {
         "Sid":"Allow attachment of persistent resources",
         "Effect":"Allow",
         "Principal":{
            "AWS": "arn:aws:iam::${var.account_number}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
         },
         "Action":[
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
         ],
         "Resource":"*",
         "Condition":{
            "Bool":{
               "kms:GrantIsForAWSResource":"true"
            }
         }
      },
      {
          "Sid": "Allow Lambda role use of the Customer Managed Keys",
          "Effect": "Allow",
          "Principal": {
              "AWS": "arn:aws:iam::${var.account_number}:role/assume_role_shared_service_cloudOps"
          },
          "Action": [
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*",
              "kms:DescribeKey",
              "kms:CreateGrant"
          ],
          "Resource": "*"
      }
   ]
}
EOT
}

# data "aws_ssm_parameter" "ebs_kms_key_id"{
#   name = var.ebs_kms_key_id
# }

resource "aws_ebs_default_kms_key" "ebs_kms_key" {
  key_arn = aws_kms_key.ebs_kms.arn
  # key_arn = "arn:aws:kms:${var.region}:${var.account_number}:key/${data.aws_ssm_parameter.ebs_kms_key_id.value}"
}


# Add an alias to the key
resource "aws_kms_alias" "eks_ng_instance_ebs_kms_alias" {
  name          = "alias/${var.account_name}-eks-ebs-kms"
  target_key_id = aws_kms_key.ebs_kms.key_id
}

############################################################################################################
# Create EKS Cluster using Terraform Module
# Reference : https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
############################################################################################################


module "eks_cluster" {
  source  = "./modules/terraform-aws-eks-master"
  # version = "~> 18.0"

  depends_on = [
    aws_iam_role.eks_cluster_admin_role,
    # aws_iam_role.eks_webapi_apps_role,
    # aws_iam_role.eks_wcms_apps_role,
    # aws_iam_policy.eks_ng_appmesh_xray_policy,
    # aws_iam_policy.eks_ng_autoscaling_policy,
    # aws_iam_policy.eks_ng_awsloadbalancer_policy,
    # aws_iam_policy.eks_ng_externaldnschangeset_policy,
    #aws_iam_policy.eks_ng_externaldnshostedzones_policy,
    # aws_iam_policy.eks_ng_xray_policy,
    module.eks_self_managed_primary_security_group,
    module.eks_self_managed_additional_security_group,
    module.eks_controlplane_primary_security_group,
    aws_security_group.eks_controlplane_additional_security_group,
    # aws_iam_role_policy_attachment.eks_ng_AmazonEKSVPCResourceController_attachment,
    # aws_iam_role_policy_attachment.eks_ng_AmazonEC2ContainerRegistryPowerUser_attachment,
    # aws_iam_role_policy_attachment.eks_ng_AmazonEKSWorkerNodePolicy_attachment,
    aws_iam_role_policy_attachment.eks_ng_AmazonEKS_CNI_Policy_attachment,
    # aws_iam_role_policy_attachment.eks_ng_AmazonEC2ContainerRegistryReadOnly_attachment,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKS_CNI_Policy_attachment,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController_attachment
  ]

  cluster_name    = "${var.account_name}-${var.environment}-cluster"
  cluster_version = "1.26"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # vpc_id     = var.vpc_id
  # subnet_ids = [var.public_subnet_id_1, var.public_subnet_id_2, var.private_subnet_id_1, var.private_subnet_id_2, var.outpost_private_subnet_id]

  # Supply our own IAM Role
  create_iam_role = false
  iam_role_arn  = aws_iam_role.eks_cluster_role.arn

  # Do Not Create Cluster Security Group.
  create_cluster_security_group = false
  # Add Cluster Security Group - Primary
  cluster_security_group_id = module.eks_controlplane_primary_security_group.out_id
  # Add Cluster Security Group - Additional
  cluster_additional_security_group_ids = [aws_security_group.eks_controlplane_additional_security_group.id]
  # Cloudwatch log group
  create_cloudwatch_log_group = false

  # Self Managed Node Group(s)
  # self_managed_node_group_defaults = {
  #   instance_type                          = var.environment == "prod" ? "m5.2xlarge" : "m5.xlarge"
  #   update_launch_template_default_version = true

  #   iam_role_name = "${var.account_name}-ng-outpost-role"

  #   subnet_ids = [var.outpost_private_subnet_id]

  #   ami_id  = var.k8s_ami_id

  #   # Manage our own Security Group
  #   create_security_group = false
  #   vpc_security_group_ids = [module.eks_self_managed_primary_security_group.out_id, module.eks_self_managed_additional_security_group.out_id]


  #   # Supply our own IAM Role
  #   create_iam_instance_profile = false
  #   iam_instance_profile_arn  = aws_iam_instance_profile.eks_node_group_instance_profile.arn

  #   metadata_options = local.metadata_options

  #   block_device_mappings = [
  #     {
  #       device_name = "/dev/sdb"
  #       ebs         = [
  #         {
  #           encrypted   = true
  #           delete_on_termination   = true
  #           kms_key_id  = aws_kms_key.ebs_kms.arn
  #           # kms_key_id  = "arn:aws:kms:ap-southeast-3:049987190305:key/76b7f0b5-e504-48d1-b81e-bb47473127e6"${var.ebs_kms_key_id}
  #           volume_size = 50
  #           volume_type             = "gp2"

  #         }
  #       ]
  #     }
  #   ]
  # }

  # self_managed_node_groups = {
  #   fe-outpost = {
  #     name         = "${var.account_name}-fe-outpost"
  #     max_size     = 1
  #     desired_size = 1
  #     min_size     = 1

  #     labels = {
  #       resource        = "outposts"
  #       family          = "frontend"
  #     }

  #     tags = {
  #       resource        = "outposts"
  #       family          = "frontend"
  #     }

  #   }
  #   be-outpost = {
  #     name         = "${var.account_name}-be-outpost"
  #     max_size     = 1
  #     desired_size = 1
  #     min_size     = 1

  #     labels = {
  #       resource        = "outposts"
  #       family          = "backend"
  #     }

  #     tags = {
  #       resource        = "outposts"
  #       family          = "backend"
  #     }

  #   }
  # }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    # disk_size      = 50
    instance_types = ["m5.xlarge","m5.2xlarge"]
    update_launch_template_default_version = true

    iam_role_name = "${var.account_name}-${var.environment}-ng-region-role"

    # ami_id  = var.k8s_ami_id

    # Manage our own Security Group
    create_security_group = false
    # attach_cluster_primary_security_group = true
    vpc_security_group_ids  = [module.eks_controlplane_primary_security_group.out_id]

    # Supply our own IAM Role
    create_iam_role = false
    iam_role_arn  = aws_iam_role.eks_node_group_role.arn

    subnet_ids = [var.private_subnet_id_1, var.private_subnet_id_2]

    metadata_options = local.metadata_options

    block_device_mappings = [
      {
        device_name = "/dev/sdb"
        ebs         = [
          {
            encrypted               = true
            delete_on_termination   = true
            #kms_key_id              = var.training-lz-local-ebs
            kms_key_id              = aws_kms_key.ebs_kms.arn
            volume_size             = 50
            volume_type             = "gp2"

          }
        ]
      }
    ]
  }


  eks_managed_node_groups = {
    # cc-cluster = {
    #   name          = "${var.account_name}-${var.environment}-cc-cluster-ng"
    #   instance_types = ["m5.2xlarge"] #["m5.xlarge"]
    #   disk_size      = 100
    #   min_size      = 0
    #   max_size      = 10
    #   desired_size  = 0

    #   labels = {
    #     resource        = "region"
    #     family          = "frontend"
    #   }

    #   tags = {
    #     resource        = "region"
    #     family          = "frontend"
    #   }
    # }
    # cc-cluster-v1 = {
    #   name          = "${var.account_name}-cc-cluster-ng-new"
    #   instance_types = ["m5.2xlarge"]
    #   disk_size      = 100
    #   min_size      = 1
    #   max_size      = 10
    #   desired_size  = 2
    #   ami_id  = var.k8s_ami_id
    #   enable_bootstrap_user_data = true
    #   platform = "linux"
    #   labels = {
    #     resource        = "region"
    #     family          = "frontend"
    #   }

    #   tags = {
    #     resource        = "region"
    #     family          = "frontend"
    #   }
    # }
    # ol-cluster = {
    #   name          = "${var.account_name}-${var.environment}-ol-cluster-ng"
    #   instance_types = ["m5.2xlarge"] #["m5.xlarge"]
    #   disk_size      = 100
    #   min_size     = 1
    #   max_size     = 10
    #   desired_size = 1

    #   labels = {
    #     resource        = "region"
    #     family          = "backend"
    #   }

    #   tags = {
    #     resource        = "region"
    #     family          = "backend"
    #   }
    # }
    # ol-cluster-v1 = {
    #   name          = "${var.account_name}-ol-cluster-ng-new"
    #   instance_types = ["m5.2xlarge"]
    #   disk_size      = 100
    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 4
    #   ami_id  = var.k8s_ami_id
    #   enable_bootstrap_user_data = true
    #   platform = "linux"
    #   labels = {
    #     resource        = "region"
    #     family          = "backend"
    #   }

    #   tags = {
    #     resource        = "region"
    #     family          = "backend"
    #   }
    # }

    cc-cluster-v2 = {
      name          = "${var.account_name}-cc-cluster-ng-new-v2"
      instance_types = ["t3.medium"]
      #create_launch_template = true
      #disk_size      = 100
      min_size      = 1
      max_size      = 4
      desired_size  = 2
      ami_id  = var.k8s_ami_id
      enable_bootstrap_user_data = true
      platform = "linux"
      labels = {
        resource        = "region"
        family          = "frontend"
      }

      tags = {
        resource        = "region"
        family          = "frontend"
      }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs         = [
            {
              encrypted               = true
              delete_on_termination   = true
              #kms_key_id              = var.training-lz-local-ebs
              kms_key_id              = aws_kms_key.ebs_kms.arn
              volume_size             = 100
              volume_type             = "gp3"
  
            }
          ]
        }
      ]
    }

    ol-cluster-v2 = {
      name          = "${var.account_name}-ol-cluster-ng-new-v2"
      instance_types = ["t3.medium"]
      disk_size      = 100
      # create_launch_template = false
      # launch_template_name = ""
      min_size     = 1
      max_size     = 52
      desired_size = 19
      ami_id  = var.k8s_ami_id
      enable_bootstrap_user_data = true
      platform = "linux"
      labels = {
        resource        = "region"
        family          = "backend"
      }

      tags = {
        resource        = "region"
        family          = "backend"
      }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs         = [
            {
              encrypted               = true
              delete_on_termination   = true
              ####kms_key_id              = var.-local-ebs
              kms_key_id              = aws_kms_key.ebs_kms.arn
              volume_size             = 100
              volume_type             = "gp3"
  
            }
          ]
        }
      ]
    }

    ol-cluster-test = {
      name          = "${var.account_name}-be-without-consul"
      instance_types = ["t3.medium"]
      disk_size      = 100
      # create_launch_template = false
      # launch_template_name = ""
      min_size     = 1
      max_size     = 2
      desired_size = 2
      ami_id  = "ami-01aa9c7879e4f4c33"
      enable_bootstrap_user_data = true
      platform = "linux"
      labels = {
        resource        = "region-test"
        family          = "backend-test"
      }

      tags = {
        resource        = "region-test"
        family          = "backend-test"
      }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs         = [
            {
              encrypted               = true
              delete_on_termination   = true
              #kms_key_id              = var.training-lz-local-ebs
              kms_key_id              = aws_kms_key.ebs_kms.arn
              volume_size             = 100
              volume_type             = "gp3"
  
            }
          ]
        }
      ]
    }

    lunar-region = {
      name          = "${var.account_name}-lunar"
      instance_types = ["t3.medium"]
      disk_size      = 100
      # create_launch_template = false
      # launch_template_name = ""
      min_size     = 1
      max_size     = 2
      desired_size = 2
      ami_id  = var.k8s_ami_id
      enable_bootstrap_user_data = true
      platform = "linux"
      labels = {
        resource        = "region"
        family          = "lunar"
      }

      tags = {
        resource        = "region"
        family          = "lunar"
      }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs         = [
            {
              encrypted               = true
              delete_on_termination   = true
              #kms_key_id              = var.training-lz-local-ebs
              kms_key_id              = aws_kms_key.ebs_kms.arn
              volume_size             = 100
              volume_type             = "gp3"
  
            }
          ]
        }
      ]
    }

  }



  # # aws-auth configmap
  # create_aws_auth_configmap = true
  # manage_aws_auth_configmap = true
  
  # aws_auth_roles = [
  #   {
  #     rolearn  = aws_iam_role.eks_cluster_admin_role.arn
  #     username = "${var.account_name}-eks-cluster-role"
  #     groups   = ["system:masters"]
  #   }
  #   ,
  #   {
  #     rolearn  = aws_iam_role.eks_webapi_apps_role.arn
  #     username = "${var.account_name}-eks-webapi-apps-role"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     rolearn  = aws_iam_role.eks_wcms_apps_role.arn
  #     username = "${var.account_name}-eks-wcms-apps-role"
  #     groups   = ["system:masters"]
  #   },
  # ]
}
