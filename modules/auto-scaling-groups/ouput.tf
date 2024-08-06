
output "out_region_asg_name" {
    value = aws_autoscaling_group.auto_scaling_group.name
}

output "out_region_asg_arn" {
    value = aws_autoscaling_group.auto_scaling_group.arn
}