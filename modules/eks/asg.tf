data "assume_role_policy" "assume_role" {
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
  name = "ec2rRoleForSSM"
  path = "/"
  assume_role_policy = data.assume_role_policy.assume_role
}

resource "iam_instance_profile" "instance_profile" {
  name  = "ec2-instance-profile"
  role = aws_iam_role.ec2role.name
}

resource "aws_launch_template" "eks-lt" {
    name = "${terraform-workspace}-eks-LT"
    block_device_mappings {
      device_name = "/dev/sdb"
      ebs {
         volume_size = 20
         volume_type = "gp3"
      }
    }
    image_id = "ami-08ca1d1e465fbfe0c"
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t3a.medium"
    key_name = "bankapp-poc.pem"
    iam_instance_profile {
      name = iam_instance_profile.instance_profile.name
    }
    vpc_security_group_ids = [aws_security_group.eks-sg]
    tags = {
        Name = "${terraform.workspace}eks-cluster-nodegroup"
        environment = var.env 
    }
}

resource "aws_autoscaling_group" "eks_asg" {
    name = "${terraform.workspace}-eks-asg"
    max_size = "5"
    min_size = "0"
    desired_capacity = "0"
    force_delete = true 
    launch_template {
      id = aws_launch_template.eks-lt.name 
      version = "$LATEST"
    }
}