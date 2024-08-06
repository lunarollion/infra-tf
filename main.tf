/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/

#currently Terraform has not support ap-southeast-3
# Issue: https://github.com/hashicorp/terraform-provider-aws/issues/22252

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      version = ">= 3.8, != 3.14.0, < 4.0"
    }
    template = {
      source = "hashicorp/template"
    }
    time = {
      source = "hashicorp/time"
    }
  }

  # backend "s3" {
  #   # Replace this with your bucket name!
  #   bucket                 = "training-tfstate"  #"<Your Bucket Name>"
  #   key                    = "terraform-states/training/terraform.tfstate"
  #   region                 = "ap-northeast-1" #"<Your Region>"
  #   skip_region_validation = true
  #   # Not mandatory
  #   # profile = "gandiCloud" #"<Your AWS Profile>"

  #   # Replace this with your DynamoDB table name!
  #   dynamodb_table = "training-locking"  #"<Your Dynamo DB>"
  #   encrypt        = true
  # }

  # required_version = ">= 0.13"
}


# Configure the AWS Provider
provider "aws" {
  region                 = "ap-southeast-1" #"<Your Region>"
  skip_region_validation = true
  # Not mandatory
  #profile = "gandiCloud" #"<Your AWS Profile>"
  # default_tags {
  #   tags = {
  #     Created_by      = "TerraformManaged"
  #     OwnerTeam       = var.owner_team
  #     OwnerTeamEmail  = var.owner_email
  #     Environment     = var.environment
  #     ApplicationName = var.account_name
  #     CostCenter      = var.cost_center
  #     Downtime        = var.downtime
  #     PatchGroup      = var.patch_group
  #     MaintenanceWindow = var.maintenance_window
  #   }
  # }
}


# ##################################################
# # Retrieving Values from SSM Parameter Store
# ##################################################
# data "aws_ssm_parameter" "owner_team"{
#   name = var.owner
# }

# data "aws_ssm_parameter" "owner_team_email"{
#   name = var.owner_email
# }

# data "aws_ssm_parameter" "account_name"{
#   name = var.account_name
# }

# data "aws_ssm_parameter" "cost_center"{
#   name = var.cost_center
# }
