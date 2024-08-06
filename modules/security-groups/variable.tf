variable "name" {
    description = "Name of the security group"
}

variable "description" {
    description = "Description of utilization of the security group."
}

variable "vpc_id" {
    description = "The VPC Id"
}


variable "security_group_rules" {
    description = "List of Security Group Rules"  
}


# variable "redis_replicas_number" {
#     description = "List of Security Group Rules"  
# }