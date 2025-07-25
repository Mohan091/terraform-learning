resource "aws_security_group" "eks-sg" {
  name = "${terraform.workspace}-eks-cluster-sg"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        self = true
    },
    {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        self = true
    }
  ]
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 21.0"
}