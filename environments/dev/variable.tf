# variable "vpc_name" {
#   description = "Name of VPC"
#   type        = string
#   default     = "custom-vpc"
# }
# variable "env" {
#   description = "Environment name"
#   type        = string
#   default     = "dev"
# }
# variable "cidr_block" {
#   description = "CIDR value of VPC"
#   type        = string
# }
# variable "azs" {
#   description = "AZ for the Subnets"
#   type        = list(string)
#   default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
# }
# variable "public_subnets" {
#   description = "CIDR of public subnets"
#   type        = list(string)
# }
# variable "private_subnets" {
#   description = "CIDR of private subnets"
#   type        = list(string)
# }
# variable "enable_nat_gateway" {
#   description = "If NAT gateway required"
#   type        = bool
#   default     = false
# }
# variable "tags" {
#   description = "TAGS for resources going to be created"
#   type        = map(string)
#   default = {
#     Created_By = "Mohan Mouyra"
#   }
# }

######################### EKS Cluster Variables ###########################################

variable "cluster_sg_name" {
  type        = string
  description = "EKS Cluster SG Name"
}
variable "nodegroup_sg_name" {
  type        = string
  description = "Nodegroup SG Name"
}
variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}
variable "launch_template_name" {
  type        = string
  description = "Launch template name"
}
variable "cluster_role_name" {
  type        = string
  description = "EKS Cluster role name"
}
variable "cluster_policy_name" {
  type        = string
  description = "EKS cluster policy name"
}
variable "nodegroup_role_name" {
  type        = string
  description = "Nodegroup role name"
}
variable "asg_name" {
  type        = string
  description = "ASG name"
}
variable "ssm_role" {
  type        = string
  description = "EC2 SSM Role"
}