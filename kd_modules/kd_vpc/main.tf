resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block[0]
  availability_zone = var.avail_zone_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public_subnet_1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block[1]
  availability_zone = var.avail_zone_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public_subnet_2"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block[0]
  availability_zone = var.avail_zone_1a
  tags = {
    Name = "${var.env_prefix}-private_subnet_0"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block[1]
  availability_zone = var.avail_zone_1b
  tags = {
    Name = "${var.env_prefix}-private_subnet_1"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.env_prefix}-nat_gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.env_prefix}-nat_eip"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_prefix}-public_route"
  }
}
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.env_prefix}-private_route"
  }
}
resource "aws_route_table_association" "public_route_associate_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "public_route_associate_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "private_route_associate_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route.id
}
resource "aws_route_table_association" "private_route_associate_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route.id
}