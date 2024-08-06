/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/

######################
# Creating Resources
######################

# 1. Launch Template
resource "aws_launch_template" "launch_template" {
  name = "${var.name}-launchtemplate"
  image_id      = var.image_id 
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }
  vpc_security_group_ids = var.security_groups

  lifecycle {
    create_before_destroy = false
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
    volume_type = "gp2"
    volume_size = var.volume_size
    delete_on_termination = true
    encrypted = true
  }
}

}

# 2. Create AutoScalingGroup.
resource "aws_autoscaling_group" "auto_scaling_group" {
  depends_on = [
    #aws_launch_configuration.launch_config
    aws_launch_template.launch_template
  ]

  name                      = "${var.name}-asg"
  #launch_configuration      = aws_launch_configuration.launch_config.name
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  wait_for_capacity_timeout = "0"
  vpc_zone_identifier       = var.vpc_zone_identifier

  target_group_arns         = var.target_group_arns

  # target_group_arns         = [aws_lb_target_group.target_group.arn]
  protect_from_scale_in     = false
  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      launch_template
    ]
  }

  timeouts {
    delete = "60m"
  }

  tag {
    key = "Name"
    value = "${var.name}-server"
    propagate_at_launch = true
  }

  tag {
    key = "Scale Opt-In"
    value = var.name
    propagate_at_launch = true
  }
}

# 3. Create Scaling Policy
resource "aws_autoscaling_policy" "autoscaling_policy" {
  depends_on = [
    aws_autoscaling_group.auto_scaling_group
  ]

  name                    = "${var.name}-autoscale-policy"
  autoscaling_group_name  = aws_autoscaling_group.auto_scaling_group.name
  policy_type             = "TargetTrackingScaling"
  estimated_instance_warmup = var.estimate_warm_up

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.scaleout_target_percentage
    disable_scale_in = false
  }
}