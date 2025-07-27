locals {
  environment = terraform.workspace
}

module "vpc" {
  env                = local.environment
  source             = "../../modules/vpc"
  vpc_name           = var.vpc_name
  cidr               = var.cidr_block
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  tags = {
    Environment = "${terraform.workspace}"
    Created_By  = "${var.tags.Created_By}"
  }
}

module "eks" {
  source               = "../../modules/eks/"
  cluster_name         = var.cluster_name
  asg_name             = var.asg_name
  cluster_role_name    = var.cluster_role_name
  cluster_policy_name  = var.cluster_policy_name
  nodegroup_role_name  = var.nodegroup_role_name
  cluster_sg_name      = var.cluster_sg_name
  launch_template_name = "${terraform.workspace}-eks-lt"
  ssm_role             = var.ssm_role

}
