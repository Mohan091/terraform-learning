data "aws_iam_policy_document" "ng_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "nodegroup_role" {
  assume_role_policy = data.aws_iam_policy_document.ng_assume_role.json
  name               = "${terraform.workspace}-${var.nodegroup_role_name}"
}

resource "aws_iam_role_policy_attachment" "worker_CNI" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "ECR_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup_workernode" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_eks_node_group" "eks_nodegroup" {
  node_group_name = "${terraform.workspace}-nodegroup"
  cluster_name    = module.eks.cluster_name
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = ["subnet-0f764db305c5e677d","subnet-0059910fbcc450a69","subnet-042f9a30c03bb3bbd"]   #module.vpc.subnet_ids
  scaling_config {
    min_size     = "0"
    max_size     = "3"
    desired_size = "1"
  }
  launch_template {
    name    = aws_launch_template.eks_lt.name
    version = aws_launch_template.eks_lt.latest_version
  }
  depends_on = [
    aws_iam_role_policy_attachment.worker_CNI,
    aws_iam_role_policy_attachment.nodegroup_workernode,
    aws_iam_role_policy_attachment.ECR_registry,
    aws_iam_role_policy_attachment.nodegroup_ssm
  ]
}


