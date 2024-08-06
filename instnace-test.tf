#####################
## Create IAM Role
#####################
resource "aws_iam_role" "bastion_role" {
  name = "${var.account_name}-bastion"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

############################
## Create Instance Profile #
############################

resource "aws_iam_instance_profile" "bastion_instance_profile_new" {
  name = "${var.account_name}-${var.environment}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}
resource "aws_instance" "ec2_bastion" {
  depends_on = [
    module.bastion_sg
  ]
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile_new.name
  instance_type = var.ec2_type_bastion_new
  vpc_security_group_ids = [module.bastion_sg.out_id]
  subnet_id = var.private_subnet_id_2
  associate_public_ip_address = false
  ami = var.ec2_imageid_bastion_new
  key_name = "ec2-host-for-testing"

  lifecycle {
    create_before_destroy = false
  }

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp3"
    volume_size = var.ec2_ebs_volume_bastion_new
    delete_on_termination = true
    encrypted = true
  }

  # tags = {
  #   Name = "${var.account_name}-${var.environment}-bastion"
  #   map-migrated = "mig46117"
  # }
  # tags_all = {
  #   map-migrated = "mig46117"
  # }
}
