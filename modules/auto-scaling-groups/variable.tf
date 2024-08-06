variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "environment" {
  description = "The application SDLC Environment."
  validation {
    condition = contains(
        ["prod", "pre-prod", "dev"], var.environment
    )
    error_message = "SDLC environment that you put is not in the list."
  }
}


variable "iam_instance_profile" {
    description = "IAM Instance Profile"
}

variable "security_groups" {
  type = list(string)
  description = "List Security Group that will be attached to the instance"
}

variable "vpc_id" {
    description = "The VPC Id"
}

variable "name" {
  description = "Name of the component"
}

variable "instance_type" {
  description = "Instance types that can be used."
  validation {
    condition = contains(
        ["m5.large", "m5.xlarge", "m5.2xlarge", "r5.large"], var.instance_type
    )
    error_message = "Instance type that you entered is not in the list."
  }
}

variable "volume_size" {
  type = number
  description = "Intended volume size for the EBS storage."
}

variable "target_group_arns" {
  type = list(string)
  description = "List of ARN of the target group"
}

variable "min_size" {
  type        = number 
  description = "Minimum Size or capacity of the AutoScaling Group."
}

variable "max_size" {
  type        = number
  description = "Maximum Size or capacity of the AutoScaling Group."
}

variable "desired_capacity" {
  type        = number
  description = "Desired Size or capacity of the AutoScaling Group."
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "Subnet Ids which are covered by Auto Scaling Group."
}

variable "scaleout_target_percentage" {
  type        = number
  description = "Target Percentage of CPU Utilization to Scale Out."
}

variable estimate_warm_up {
  type = number
  default = 300
}

