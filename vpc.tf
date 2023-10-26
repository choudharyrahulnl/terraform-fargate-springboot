provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

# VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = {
    Name = "prod-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "eu-west-1a"
  tags              = {
    Name = "prod-public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "eu-west-1b"
  tags              = {
    Name = "prod-public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "eu-west-1c"
  tags              = {
    Name = "prod-public-subnet-3"
  }
}

# Private Subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "eu-west-1a"
  tags              = {
    Name = "prod-private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "eu-west-1b"
  tags              = {
    Name = "prod-private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = "eu-west-1c"
  tags              = {
    Name = "prod-private-subnet-3"
  }
}

# Public Route Tables
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  tags   = {
    Name = "prod-public-route-table"
  }
}

# Private Route Tables
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  tags   = {
    Name = "prod-private-route-table"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "public-subnet-3-route-table-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}

# Private Route Table Associations
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-3.id
}

# Elastic IP
resource "aws_eip" "elastic-ip-for-nat-gateway" {
  associate_with_private_ip = "10.0.0.5"
  tags                      = {
    Name = "prod-elastic-ip-for-nat-gateway"
  }
  depends_on = [aws_internet_gateway.internet-gateway]
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elastic-ip-for-nat-gateway.id
  subnet_id     = aws_subnet.public-subnet-1.id
  tags          = {
    Name = "prod-nat-gateway"
  }
  depends_on = [aws_eip.elastic-ip-for-nat-gateway]
}

# Associate NAT Gateway with Private Route Table
resource "aws_route" "nat-gateway-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.prod-vpc.id
  tags   = {
    Name = "prod-internet-gateway"
  }
}

# Associate Internet Gateway with Public Route Table
resource "aws_route" "internet-gateway-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}