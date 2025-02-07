provider "aws" {
    region = "stockhom"
     }
     resource "aws_vpc" "private_vpc" {
        cidr_block = "10.0.0.0/16"
        enable_dns_support = true
        enable_dns_hostnames = true
        tags = {
    Name = "PrivateVPC"
  }
}
resource "aws_subnet" "private_subnet_1" {
     vpc_id            = aws_vpc.private_vpc.id
     cidr_block        = "10.0.1.0/24"
     availability_zone = "stockhom"
     map_public_ip_on_launch = false
tags = {
    Name = "PrivateSubnet1"
  }
}
resource "aws_subnet" "private_subnet_2" {
    vpc_id            = aws_vpc.private_vpc.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
     tags = {
    Name = "PrivateSubnet2"
  }
}
resource "aws_internet_gateway" "igw" {
     vpc_id = aws_vpc.private_vpc.id
     tags = {
    Name = "PrivateVPC-IGW"
  }
}
resource "aws_nat_gateway" "nat" {
     allocation_id = aws_eip.nat.id
     subnet_id     = aws_subnet.private_subnet_1.id
     tags = {
    Name = "NATGateway"
  }
}
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.private_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}