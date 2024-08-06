# /*---------------------------------------------------------------------------------------
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
# ---------------------------------------------------------------------------------------*/

# References : https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html

#############################################
### Security group for Pods - webapi
#############################################

module "webapi_eks_pods_security_group" {
    source = "./modules/security-groups"

  name        = "${var.account_name}-webapi-eks-pods-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id

  security_group_rules  = [
    # {
    #   protocol        = "tcp"
    #   from_port       = 443
    #   to_port         = 443
    #   type            = "egress"
      
    #   description     = "Minimum Outbound traffic to Control Plane"
    #   cidr_blocks     = null
    #   self            = false
    #   source_security_group_id  = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
    # }
    # ,
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "ingress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "egress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    }
  ]
}

#############################################
### Security group for Pods - wcms
#############################################
module "wcms_eks_pods_security_group" {
    source = "./modules/security-groups"

  name        = "${var.account_name}-wcms-eks-pods-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id

  security_group_rules  = [
    # {
    #   protocol        = "tcp"
    #   from_port       = 443
    #   to_port         = 443
    #   type            = "egress"
      
    #   description     = "Minimum Outbound traffic to Control Plane"
    #   cidr_blocks     = null
    #   self            = false
    #   source_security_group_id  = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
    # }
    # ,
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "ingress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "egress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    }
  ]
}

#############################################
### Security group for Cluster Control PLane
#############################################
module "eks_controlplane_primary_security_group" {
  source = "./modules/security-groups"

  name        = "${var.account_name}-eks-controlplane-primary-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id 

  security_group_rules  = [
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "ingress"
      
      description     = "Allow Inter Node communication"
      cidr_blocks     = null
      self            = true
      source_security_group_id  = null
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "egress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    },
    ############################################################################
    # Add this part for Pod Security Group -- So that, the Pod can reach DNS.
    ############################################################################
    {
      protocol        = "tcp"
      from_port       = 53
      to_port         = 53
      type            = "ingress"
      
      description     = "[Additional] Allow TCP DNS query from webapi Apps"
      cidr_blocks     = null
      self            = false
      source_security_group_id  = module.webapi_eks_pods_security_group.out_id
    },
    {
      protocol        = "udp"
      from_port       = 53
      to_port         = 53
      type            = "ingress"
      
      description     = "[Additional] Allow UDP DNS query from webapi Apps"
      cidr_blocks     = null
      self            = false
      source_security_group_id  = module.webapi_eks_pods_security_group.out_id
    },
    ##############################################################################
    ##############################################################################
    {
      protocol        = "tcp"
      from_port       = 53
      to_port         = 53
      type            = "ingress"
      
      description     = "[Additional] Allow TCP DNS query from wcms Apps"
      cidr_blocks     = null
      self            = false
      source_security_group_id  = module.wcms_eks_pods_security_group.out_id
    },
    {
      protocol        = "udp"
      from_port       = 53
      to_port         = 53
      type            = "ingress"
      
      description     = "[Additional] Allow UDP DNS query from wcms Apps"
      cidr_blocks     = null
      self            = false
      source_security_group_id  = module.wcms_eks_pods_security_group.out_id
    },
	  # ####################################
    # # Allow inbound from Consul Server #
    # ####################################
    # {
    #   protocol        = "tcp"
    #   from_port       = 8301
    #   to_port         = 8600 #8502
    #   type            = "ingress"
      
    #   description     = "Port 8301 to 8502 from Consul Server - IPv4"
    #   cidr_blocks     = [var.consul_cidr_subnet_1,var.consul_cidr_subnet_2,var.consul_cidr_subnet_3]
    #   self            = false
    #   source_security_group_id = null
    # },
    # {
    #   protocol        = "tcp"
    #   from_port       = 21000
    #   to_port         = 21255
    #   type            = "ingress"
      
    #   description     = "Port 21000 to 21255 from Consul Server - IPv4"
    #   cidr_blocks     = [var.consul_cidr_subnet_1,var.consul_cidr_subnet_2,var.consul_cidr_subnet_3]
    #   self            = false
    #   source_security_group_id = null
    # },
    # {
    #   protocol        = "udp"
    #   from_port       = 8301
    #   to_port         = 8600 #8502
    #   type            = "ingress"
      
    #   description     = "Port 8301 to 8502 from Consul Server - IPv4"
    #   cidr_blocks     = [var.consul_cidr_subnet_1,var.consul_cidr_subnet_2,var.consul_cidr_subnet_3]
    #   self            = false
    #   source_security_group_id = null
    # },
  ]
}

resource "aws_security_group" "eks_controlplane_additional_security_group" {
  name        = "${var.account_name}-eks-controlplane-addtional-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id 

  tags = {
    map-migrated = "mig46117"
  }
  tags_all = {
    map-migrated = "mig46117"
  }
}

###############################################
### Security group for Self Managed Node Group
###############################################
module "eks_self_managed_primary_security_group" {
  source = "./modules/security-groups"

  depends_on = [
    module.eks_controlplane_primary_security_group
  ]

  name        = "${var.account_name}-eks-self-managed-primary-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id 


  security_group_rules  = [
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "ingress"
      
      description     = "Allow Inter UnManaged-Node communication"
      cidr_blocks     = null
      self            = true
      source_security_group_id  = null
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "ingress"
      
      description     = "Allow Inter (All) Node communication"
      cidr_blocks     = null
      self            = false
      source_security_group_id  = module.eks_controlplane_primary_security_group.out_id
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "egress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    }
  ]
}

module "eks_self_managed_additional_security_group" {
  source = "./modules/security-groups"

  depends_on = [
    aws_security_group.eks_controlplane_additional_security_group
  ]

  name        = "${var.account_name}-eks-self-managed-addtional-sg"
  description = "Inbound and Outbound Traffic to Node Security Group"
  vpc_id      = var.vpc_id 

  security_group_rules  = [
    {
      protocol        = "tcp"
      from_port       = 443
      to_port         = 443
      type            = "ingress"
      
      description     = "All Access Inbound 443 from Control Plane Additional Security Group"
      cidr_blocks     = null
      self            = false
      source_security_group_id = aws_security_group.eks_controlplane_additional_security_group.id
    },
    {
      protocol        = "tcp"
      from_port       = 1025
      to_port         = 65535
      type            = "ingress"
      
      description     = "All Access Inbound 1025-65535 from Control Plane Additional Security Group"
      cidr_blocks     = null
      self            = false
      source_security_group_id = aws_security_group.eks_controlplane_additional_security_group.id
    },
    {
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      type            = "egress"
      
      description     = "All Access Outbound - IPv4"
      cidr_blocks     = ["0.0.0.0/0"]
      self            = false
      source_security_group_id = null
    }
  ]
}
###############################################
# Additional Security Group Rules
###############################################
# Additional Security Group Rules for Control Plane - Primary
resource "aws_security_group_rule" "eks_controlplane_primary_security_group_rule" {
  depends_on = [
    module.eks_controlplane_primary_security_group, module.eks_self_managed_primary_security_group
  ]

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_self_managed_primary_security_group.out_id
  security_group_id = module.eks_controlplane_primary_security_group.out_id
  description       = "[Additional] Ingress All communication from UnManaged Node to Control Plane"
  
}

# Additional Security Group Rules for Control Plane - Additional
resource "aws_security_group_rule" "eks_controlplane_additional_security_group_ingress_rule" {
  depends_on = [
    aws_security_group.eks_controlplane_additional_security_group, module.eks_self_managed_additional_security_group
  ]

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.eks_self_managed_additional_security_group.out_id
  security_group_id = aws_security_group.eks_controlplane_additional_security_group.id
  description       = "[Additional] Ingress 443 communication from  UnManaged Node to Control Plane"
}

resource "aws_security_group_rule" "eks_controlplane_additional_security_group_egress_ephemeral_rule" {
  depends_on = [
    aws_security_group.eks_controlplane_additional_security_group, module.eks_self_managed_additional_security_group
  ]

  type              = "egress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = module.eks_self_managed_additional_security_group.out_id
  security_group_id = aws_security_group.eks_controlplane_additional_security_group.id
  description       = "[Additional] Egress 1025-65535 (ephemeral) communication from Control Plane to UnManaged Node"
}

resource "aws_security_group_rule" "eks_controlplane_additional_security_group_egress_443_rule" {
  depends_on = [
    aws_security_group.eks_controlplane_additional_security_group, module.eks_self_managed_additional_security_group
  ]

  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.eks_self_managed_additional_security_group.out_id
  security_group_id = aws_security_group.eks_controlplane_additional_security_group.id
  description       = "[Additional] Egress 443 communication from Control Plane to UnManaged Node"
}
