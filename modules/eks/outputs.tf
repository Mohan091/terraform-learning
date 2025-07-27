output "cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_version" {
  value = module.eks.cluster_version
}
output "node_group_name" {
  value = aws_eks_node_group.eks_nodegroup.arn
}
output "launch_template_name" {
  value = aws_launch_template.eks_lt.name
}
output "asg_name" {
  value = aws_autoscaling_group.eks_asg.name
}
output "eks_cluster_role" {
  value = aws_iam_role.eks_role.arn
}
output "nodegroup_role" {
  value = aws_iam_role.nodegroup_role.arn
}
output "ssm_role" {
  value = aws_iam_instance_profile.instance_profile.arn
}