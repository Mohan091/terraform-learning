output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets[*]
}
output "private_subnets" {
  value = module.vpc.private_subnets[*]
}
output "aws_internet_gateway" {
  value = module.vpc.aws_internet_gateway
}
output "nat_gw" {
  value = module.vpc.nat_gw
}
output "eip" {
  value = module.vpc.eip
}