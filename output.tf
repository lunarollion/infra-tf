/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/


output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

# output "kubeconfig-certificate-authority-data" {
#   value = module.eks.eks_cluster.certificate_authority[0].data
# }


# output "alb_ingress_controller_policy_arn" {
#     value = aws_iam_policy.alb_ingress_controller_policy.arn
# }

# output "iam_user_k8s_cluster_admin" {
#     value = aws_iam_user.k8s_administrator_user.arn
# }

# output "iam_user_k8s_webapi_admin" {
#     value = aws_iam_user.k8s_webapi_admin_user.arn
# }

# output "iam_user_k8s_wcms_admin" {
#     value = aws_iam_user.k8s_wcms_admin_user.arn
# }

output "iam_role_eks_cluster_admin_role" {
    value = aws_iam_role.eks_cluster_admin_role.arn
}

output "oidc_provider_arn" {
    value = module.eks_cluster.oidc_provider_arn
}   

output "oidc_provider" {
    value = module.eks_cluster.oidc_provider
}

output "eks_managed_node_groups_autoscaling_group_names" {
    value = module.eks_cluster.eks_managed_node_groups_autoscaling_group_names
}

output "self_managed_node_groups_autoscaling_group_names" {
    value = module.eks_cluster.self_managed_node_groups_autoscaling_group_names
}

# output "endpoint_training_elasticache_wcms_redis"{
#     value = module.training_elasticache_wcms_redis.redis_endpoint_address
# }

# output "endpoint_training_elasticache_webapi_redis"{
#     value = module.training_elasticache_webapi_redis.redis_endpoint_address
# }

# output "endpoint_training_elasticache_wcms_redis_cfn"{
#     value = module.training_elasticache_wcms_redis_cfn.redis_endpoint_address
# }

# output "eks_region_asg_names" {
#     value = module.eks.eks_managed_node_groups_autoscaling_group_names
# }

# output "eks_outpost_region_asg_names" {
#     value = module.eks_outpost.eks_managed_node_groups_autoscaling_group_names
# }

# output "eks_outpost_asg_names" {
#     value = module.eks_outpost.self_managed_node_groups_autoscaling_group_names
# }

# output "eks_load_balancer" {
#     value = data.aws_lb.eks_load_balancers.dns_name
# }

#####################
# Allocation ID EIP #
#####################
# output "allocation_id_eip_1"{
#     value = aws_eip.eip_nlb[0].allocation_id
# }

# output "allocation_id_eip_2"{
#     value = aws_eip.eip_nlb[1].allocation_id
# }

# output "allocation_id_eip_3"{
#     value = aws_eip.eip_nlb[2].allocation_id
# }

# output "allocation_id_eip_4"{
#     value = aws_eip.eip_nlb[3].allocation_id
# }

########################################
# Role for External DNS
########################################
# output "arn_external_dns_role"{
#     value = aws_iam_role.ext_dns_role.arn
# }