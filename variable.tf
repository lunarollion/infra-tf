# /*---------------------------------------------------------------------------------------
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
# ---------------------------------------------------------------------------------------*/

variable "account_number" {
  type        = string
  description = "12 digit of the target account number."
}

variable "region" {
  description = "default region"
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "The application SDLC Environment."
  validation {
    condition = contains(
      ["training", "nft", "pre-prod", "dev"], var.environment
    )
    error_message = "SDLC environment that you put is not in the list."
  }
}

variable "account_name" {
  description = "Name of the Project"
  default = "/account/name"
}


variable "arn_admin_iam_role" {
  description = "ARN of Admin IAM Role in the account."
  # validation {
  #     condition     = can(regex("^[a-zA-Z][a-zA-Z\-\_0-9]{1,64}$", var.arn_admin_iam_role))
  #     error_message = "IAM role name must start with letter, only contain letters, numbers, dashes, or underscores and must be between 1 and 64 characters"
  #   }
}

# variable "owner_team" {
#   description = "Owner of the application. Currently only used for tagging"
#   default = "/account/platform/owner-team"
# }

# variable "owner_email" {
#   description = "Email of application owner. Currently only used for tagging"
#   default = "/account/platform/owner-team-email"
# }

# variable "cost_center" {
#   description = "Application cost-center."
#   default = "/account/cost-center"
# }

# variable "downtime" {
#   description = "Application Downtime period."
#   validation {
#     condition = contains(
#       ["weekend-only", "never", "weekday-off-peak"], var.downtime
#     )
#     error_message = "Value that you put is not in the list."
#   }
#   default = "never"
# }

# variable "patch_group" {
#   validation {
#     condition = contains(
#       ["windows-non-prod", "windows-prod", "rhel-non-prod", "rhel-prod", "amzlinux-non-prod", "amzlinux-prod"], var.patch_group
#     )
#     error_message = "Value that you put is not in the list."
#   }
#   description = "Resource Patch-group"
# }

# variable "maintenance_window" {
#   description = "Resource maintenance window"
#   default = "default"
# }

variable "vpc_id" {
  description = "The VPC Id"
}

variable "private_subnet_cidr_1" {
  description = "Private Subnet CIDR 1"
}

variable "private_subnet_cidr_2" {
  description = "Private Subnet CIDR 2"
}

##### Subnet IDs ########

variable "public_subnet_id_1" {
  description = "Public Subnet ID 1"
}

variable "public_subnet_id_2" {
  description = "Public Subnet ID 2"
}

# Private Subnet IDs
variable "private_subnet_id_1" {
  description = "Private Subnet ID 1"
}

variable "private_subnet_id_2" {
  description = "Private Subnet ID 2"
}

# # Database Subnet IDs
# variable "database_subnet_id_1" {
#   description = "Database Subnet ID 1"
# }

# variable "database_subnet_id_2" {
#   description = "Database Subnet ID 2"
# }


# # Outpost Subnet IDs
# variable "outpost_private_subnet_id" {
#   description = "Subnet ID on Outpost"
# }

# # #############################
# # # KMS for EBS
# # #############################

# # variable "training-lz-local-ebs" {
# #   type = string
# #   description = "Key used to encrypt EBS Volume"
# # }

# #############################
# # Database
# #############################
# variable "db_username" {
#   description = "Database administrator username"
#   type        = string
#   sensitive   = true
#   default = "/account/db/master/username"
# }

# variable "db_password" {
#   description = "Database administrator password"
#   type        = string
#   sensitive   = true
#   default = "/account/db/master/password"
# }

# # #############################
# # # Outpost Information
# # #############################
# # variable "outpost_vpc_id" {
# #   description = "The VPC Id of Outpost"
# # }

# # variable "outpost_region_subnet_id" {
# #   description = "Subnet ID of Region on OUtpost VPC"
# # }

# # variable "outpost_public_region_subnet_id" {
# #   description = "[Simulation Purpose] Subnet ID of Region on OUtpost VPC"
# # }


# variable "ebs_kms_key_id" {
#   description = "Default Local KMS Key Arn from the account."
#   type        = string
#   default     = "/account/kms/key-id/ebs"
# }


# #############################
# # Details for EKS Node Groups
# #############################
variable "k8s_ami_id" {
  description = "Image Id of Amazon Machine Image"
  type = string

  validation {
  condition = (
      length(var.k8s_ami_id) > 4 &&
      substr(var.k8s_ami_id, 0, 4) == "ami-"
  )
  error_message = "The image_id value must start with \"ami-\"."
  }
}



# # ######################################
# # # Details for AutoScaling of Drupal
# # ######################################

# variable "ec2_imageid" {
#   description = "Volume size for Drupal"
# }

# variable "ansible_playbook_url" {
#   description = "URL playbook.yaml"
# }

# # variable "volume_size_drupal" {
# #   description = "Volume size for Drupal"
# # }

# # variable "instance_type_drupal" {
# #   description = "Intsance type for Drupal"
# # }

# # variable "min_size_drupal" {
# #   description = "Minimal Size of AutoScaling for Drupal"
# # }

# # variable "max_size_drupal" {
# #   description = "Maximal Size of AutoScaling for Drupal"
# # }

# # variable "desired_capacity_drupal" {
# #   description = "Desired Size of AutoScaling for Drupal"
# # }

# # variable "scaleout_target_percentage_dpl" {
# #   description = "Scaling Out Target Percentage of AutoScaling for Drupal"
# # }


# ##########################################
# # Details for ElasticSearch
# ##########################################
# variable "es_username" {
#   description = "Database elasticsearch username"
#   type        = string
#   sensitive   = true
#   default = "/account/es/master/username"
# }

# variable "es_password" {
#   description = "Database elasticsearch password"
#   type        = string
#   sensitive   = true
#   default = "/account/es/master/password"
# }

# ##############################
# # Details for Subnet Consul  #
# ##############################

# variable "consul_cidr_subnet_1" {
#     type = string
#     description = "Consul CIDR subnet_1"
# }

# variable "consul_cidr_subnet_2" {
#     type = string
#     description = "Consul CIDR subnet_2"
# }

# variable "consul_cidr_subnet_3" {
#     type = string
#     description = "Consul CIDR subnet_3"
# }

# #################################
# # List of Service Account #
# #################################
# variable "apps_role_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-role"
# }

# variable "apps_role_v2_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v2-role"
# }

# variable "apps_role_v3_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v3-role"
# }

# variable "apps_role_v4_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v4-role"
# }

# variable "apps_role_v5_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v5-role"
# }

# variable "apps_role_v6_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v6-role"
# }

# variable "apps_role_v7_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v7-role"
# }

# variable "apps_role_v8_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v8-role"
# }

# variable "apps_role_v9_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v9-role"
# }

# variable "apps_role_v10_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--v10-role"
# }

# variable "apps_role_v11_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v11-role"
# }

# variable "apps_role_v12_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v12-role"
# }

# variable "apps_role_v13_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v13-role"
# }

# variable "apps_role_v14_sa" {
#   type = list(string)
#   description = "List Service Account for Role training-v14-role"
# }

# variable "apps_role_v15_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--v15-role"
# }

# variable "apps_role_v16_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--v16-role"
# }

# variable "apps_role_v17_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--v17-role"
# }

# variable "apps_role_v18_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--v18-role"
# }

# variable "apps_s3_access_role_sa" {
#   type = list(string)
#   description = "List Service Account for Role training--s3-access-role"
# }

# ######################
# # Details for Lumen #
# ######################

# variable "ec2_type_lumen" {
#     type = string
#     description = "EC2 type of Lumen"
# }

# variable "ec2_imageid_lumen" {
#     type = string
#     description = "AMI ID of Lumen"
# }

# variable "ec2_ebs_volume_lumen" {
#     type = number
#     description = "Volume of Lumen"
# }

# variable "ec2_type_lumen_new" {
#     type = string
#     description = "EC2 type of Lumen"
# }

# variable "ec2_type_lumen_r5" {
#     type = string
#     description = "EC2 type of Lumen"
# }

# variable "ec2_imageid_lumen_new" {
#     type = string
#     description = "AMI ID of Lumen"
# }

# variable "ec2_ebs_volume_lumen_new" {
#     type = number
#     description = "Volume of Lumen"
# }
# # variable "ec2_root_volume_lumen" {
# #     type = number
# #     description = "Volume of Lumen"
# # }

# # variable "count_number" {
# #     type = number
# #     description = "Count of EC2"
# # }

# variable "lumen_private_ip" {
#     type = list(string)
#     description = "List IP Ec2"
# }

# # variable "lumen_private_ip_az_b" {
# #     type = list(string)
# #     description = "List IP Ec2"
# # }

# variable "ansible_playbook_url_lumen" {
#     type = string
# }

# ##############
# # Elastic IP #
# ##############
# variable "count_number_eip" {
#     type = number
#     description = "EIP Number"
# }

# #################################
# # List of Service Account foe External DNS Role #
# #################################
# variable "ext_dns_role_sa" {
#   type = list(string)
#   description = "List Service Account for Role External DNS Role"
# }

# #############################
# # Database
# #############################

# # mysql wcms
# variable "mysql_wcms_username" {
#   description = "Database administrator username"
#   type        = string
#   sensitive   = true
#   default = "/mysql/wcms/username"
# }

# variable "mysql_wcms_password" {
#   description = "Database administrator password"
#   type        = string
#   sensitive   = true
#   default = "/mysql/wcms/password"
# }

# # variable "lumen_private_ip" {
# #     type = string
# #     description = "IP Private for Lumen"
# # }

# # variable "apps" {
# #   type = list(string)
# #   description = "List Apps"
# # }
# #################################
# # Details for Elasticache Redis #
# #################################

# # variable "redis_nodetype" {
# #     type = string
# #     description = "Node type of Redis"
# # }

# # variable "redis_subnet" {
# #     type = list(string)
# #     description = "Subnet for Elasticache Redis"
# # }

# # variable "redis_family" {
# #     type = string
# #     description = "Redis Family"
# # }

# # variable "redis_port_number" {
# #     description = "Redis Port"
# # }

# # variable "redis_shard_number" {
# #     description = "Redis Shard"
# # }

# # variable "redis_replicas_number" {
# #     description = "Redis Replicas Number"
# # }

# variable "new_lumen_private_ip" {
#     type = list(string)
#     description = "List IP Ec2"
# }

# variable "new_lumen_private_ip_a" {
#     type = list(string)
#     description = "List IP Ec2"
# }

# variable "new_lumen_private_ip_b" {
#     type = list(string)
#     description = "List IP Ec2"
# }

# ##############
# # bastion #
# ##############
variable "ec2_type_bastion_new" {
    type = string
    description = "EC2 type of Lumen"
}
variable "ec2_imageid_bastion_new" {
    type = string
    description = "EC2 type of Lumen"
}
variable "ec2_ebs_volume_bastion_new" {
    type = number
    description = "EC2 type of Lumen"
}

# #############################
# # Detail AmazonMQ
# #############################
# variable "rabbitmq_user" {
#   description = "AmazonMQ username"
#   type        = string
#   sensitive   = true
#   default     = "/account/amazonmq/username"
# }

# variable "rabbitmq_pass" {
#   description = "AmazonMQ  password"
#   type        = string
#   sensitive   = true
#   default     = "/account/amazonmq/password"
# }

# variable "rabbitmq_engine_type" {
#   description = "String"
# }

# variable "rabbitmq_engine_version" {
#   description = "String"
# }

# variable "rabbitmq_instance_type" {
#   description = "String"
# }