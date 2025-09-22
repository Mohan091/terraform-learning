# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "public_subnets" {
#   value = module.vpc.public_subnets[*]
# }
# output "private_subnets" {
#   value = module.vpc.private_subnets[*]
# }
# output "aws_internet_gateway" {
#   value = module.vpc.aws_internet_gateway
# }
# output "nat_gw" {
#   value = module.vpc.nat_gw
# }
# output "eip" {
#   value = module.vpc.eip
# }

########################################### EKS Cluster Output #########################################

output "cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_version" {
  value = module.eks.eks_cluster_version
}
output "launch_template_name" {
  value = module.eks.launch_template_name
}
output "node_group_name" {
  value = module.eks.node_group_name
}
output "nodegroup_role" {
  value = module.eks.nodegroup_role
}
output "eks_cluster_role" {
  value = module.eks.eks_cluster_role
}
output "asg_name" {
  value = module.eks.asg_name
}