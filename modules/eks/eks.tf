resource "aws_security_group" "eks-sg" {
  name   = "${terraform.workspace}-${var.cluster_sg_name}"
  vpc_id = 	"vpc-0f471ac82d8e5a8a8" #module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from internet"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true 
    description = "Allowed from self"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  name               = "${terraform.workspace}-eks-cluster-role"
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role     = aws_iam_role.eks_role.name
}

module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 21.0"
  name                                     = "${terraform.workspace}-${var.cluster_name}"
  kubernetes_version                       = "1.31"
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true
  vpc_id                                   = "vpc-0f471ac82d8e5a8a8"  #module.vpc.output.vpc_id
  subnet_ids                               = ["subnet-0f764db305c5e677d","subnet-042f9a30c03bb3bbd","subnet-0059910fbcc450a69"] #module.vpc.resource.public_subnets.id
  security_group_id                        = aws_security_group.eks-sg.id
  # addons = {
  #   coredns               = {
  #     version = "v1.11.3-eksbuild.1"
  #   }
  #   kube-proxy            = {
  #     version = "v1.31.2-eksbuild.3"
  #   }
  #   vpc-cni        = {
  #     version   = "v1.19.0-eksbuild.1"
  #   }
  #   aws-ebs-csi-driver = {
  #     version   = "v2.1.9-eksbuild.1"
  #   }
  # }
}