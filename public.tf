provider "aws" {
    region = "stockholm"
    }
    resource "aws_vpc" "my_vpc" {
         cidr_block = "10.0.0.0/16"
         enable_dns_support = true
         enable_dns_hostnames = true
         tags = {
    Name = "MyPublicVPC"
  }
}
resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "stochholm"
     tags = {
    Name = "PublicSubnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
 