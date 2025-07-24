output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}
output "private_subnets" {
  value = aws_subnet.private[*].id
}
output "aws_internet_gateway" {
  value = aws_internet_gateway.gw.id
}
output "nat_gw" {
  value = aws_nat_gateway.ngw.id
}
output "eip" {
  value = aws_eip.name.private_ip
}