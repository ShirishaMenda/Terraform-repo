# Create a VPC
resource "aws_vpc" "private" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Singapore_vpc"
  }
}

# Create public subnet1
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.private.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "public_subnet1"
  }
}

# Create public subnet2
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.private.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "public_subnet2"
  }
}

# Create private subnet1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.private.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "private_subnet1"
  }
}

# Create private subnet2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.private.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "private_subnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "net" {
  vpc_id = aws_vpc.private.id
  tags = {
    Name = "singapore_IG"
  }
}

# Public route table
resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.private.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.net.id
  }
  tags = {
    Name = "public-RT"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.pubroute.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.pubroute.id
}


# Create an Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
}

# Create NAT Gateway in public subnet
resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.private.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private.id
  }
  tags = {
    Name = "private-RT"
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}


# Security group for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.private.id

  ingress {
    description = "SSH from anywhere (be restrictive in real use)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from anywhere (be restrictive in real use)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.private.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

