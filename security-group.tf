############################################
## Security group for bastion
############################################

module "bastion_sg" {
  source = "./modules/security-groups"
  name        = "${var.account_name}-${var.environment}-bastion-sg"
  description = "Security Group for bastion"
  vpc_id      = var.vpc_id
  security_group_rules  = [
    {
      protocol        = "-1"
      from_port       = -1
      to_port         = -1
      type            = "ingress"
      description     = "Allow Traffic to All"
      cidr_blocks     = ["10.0.0.0/16"] 
      self            = false
      source_security_group_id = null
    },
    {
      protocol        = "-1"
      from_port       = -1
      to_port         = -1
      type            = "egress"
      description     = "Allow Traffic to All"
      cidr_blocks     = ["0.0.0.0/0"] 
      self            = false
      source_security_group_id = null
    }
  ]
}