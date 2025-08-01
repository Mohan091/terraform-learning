data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2role" {
  name               = "${terraform.workspace}-${var.ssm_role}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2role.name
}

resource "aws_security_group" "node-sg" {
  name   = "${terraform.workspace}-${var.nodegroup_sg_name}"
  vpc_id = 	"vpc-0f471ac82d8e5a8a8" #module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from internet"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.eks-sg.id]
    description = "Allowed from eks cluster"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/1.31/amazon-linux-2/recommended/image_id"
}


resource "aws_launch_template" "eks_lt" {
  name = "${terraform.workspace}-${var.launch_template_name}"
  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }
  image_id                             = data.aws_ssm_parameter.eks_ami.value
  # instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3a.medium"
  key_name                             = "bankapp-poc"
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.instance_profile.name
  # }
  vpc_security_group_ids = [aws_security_group.node-sg.id]
  tags = {
    Name        = "${terraform.workspace}-eks-cluster-nodegroup"
    environment = "${terraform.workspace}"
  }
  user_data = base64encode(<<-EOF
  #!/bin/bash
  /etc/eks/bootstrap.sh ${module.eks.cluster_name} \
  --kubelet-extra-args '--node-labels=eks/nodegroup=${terraform.workspace}-nodegroup'
EOF
)
}

resource "aws_autoscaling_group" "eks_asg" {
  depends_on = [ aws_launch_template.eks_lt ]
  name             = "${terraform.workspace}-${var.asg_name}"
  max_size         = "5"
  min_size         = "0"
  desired_capacity = "0"
  force_delete     = true
  availability_zones = ["us-east-2a","us-east-2b","us-east-2c"]
  launch_template {
    name = aws_launch_template.eks_lt.name
    version = "$Latest"
  }
}