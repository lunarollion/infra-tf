/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/

account_number              = "003866745935" 
region                      = "ap-southeast-1"
environment                 = "training"
account_name                = "training"
# # Get these value from SSM Parameter Store
# owner_team                  = "IT Digital Core Channel"
# owner_email                 = "support@ollion.com"
# account_name                = "training"
# cost_center                 = "cc-none"

# Get these value from IAM Role Console
arn_admin_iam_role          = "arn:aws:iam::003866745935:role/AdministratorAccess-Google"

# downtime                    = "weekend-only"
# patch_group                 = "amzlinux-prod"
# maintenance_window          = "default"

# Get these value from VPC Console
vpc_id                      = "vpc-0029007595a4852f5" 

private_subnet_cidr_1       = "10.93.64.0/23"
private_subnet_cidr_2       = "10.93.66.0/23"

public_subnet_id_1          = "subnet-07ab089debc1d6420"
public_subnet_id_2          = "subnet-08982768ac2787c5e"

private_subnet_id_1         = "subnet-0601fd436f6296ef2"
private_subnet_id_2         = "subnet-06e88cc19c82ee7e0"

# database_subnet_id_1       = "subnet-0241dd67ef0a0d7f2"
# database_subnet_id_2       = "subnet-0bf55ec174ca0d46a"

##############
# bastion #
##############
ec2_type_bastion_new    = "t3.small"
ec2_imageid_bastion_new = "ami-05ae988b831fa4858"
ec2_ebs_volume_bastion_new  = 20

################################
# Details for EKS Node Groups - Launch Template
################################

k8s_ami_id                    = "ami-0b24b4d0b23a485c4"