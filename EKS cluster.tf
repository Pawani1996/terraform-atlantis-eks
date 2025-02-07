provider "aws" {
  region = "stockhlom"
  }
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "EKS-VPC"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet1"
  }
}
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "EKS-SecurityGroup"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet1"
  }
}
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  resource "aws_iam_role" "eks_cluster_role" {
  name = "EKS-Cluster-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.private_subnet_1.id]
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}
output "kubeconfig" {
  value = aws_eks_cluster.eks_cluster.kubeconfig[0].value
}