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
