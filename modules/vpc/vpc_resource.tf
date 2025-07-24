# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "6.0.1"
#   name = ""
#   cidr = ""
#   azs = []
#   private_subnets = []
#   public_subnets = []
#   enable_nat_gateway = true 
#   one_nat_gateway_per_az = false
#   single_nat_gateway = false
#   tags = {
#     Environment = "${terraform.workspace}"
#     Created_By  = "${var.tags.Created_By}"
#   }
# }

resource "aws_vpc" "main" {
    cidr_block =  var.cidr

    tags  = merge(var.tags, {
        Name = "vpc-${var.env}"
    })
}
