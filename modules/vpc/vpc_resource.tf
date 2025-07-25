resource "aws_vpc" "main" {
    cidr_block =  var.cidr

    tags  = merge(var.tags, {
        Name = "vpc-${var.env}"
    })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = resource.aws_internet_gateway.gw.id
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "name" {
  tags = {
    Name = "${terraform.workspace}-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  # count         = length(var.public_subnets)
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.name.id
  depends_on    = [aws_eip.name]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  depends_on = [aws_nat_gateway.ngw]
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private_rt.id
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
}