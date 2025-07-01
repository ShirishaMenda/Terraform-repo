#Create vpc 
resource "aws_vpc" "name" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
    name = "3tiervpc"
  }
}

# Create public subnet1
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "public_subnet1"
  }
}

# Create public subnet2
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "public_subnet2"
  }
}

# Create private subnet1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "frontend_pvtsubnet1"
  }
}

# Create private subnet2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "frontend_pvtsubnet2"
  }
}

# Create private subnet3
resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "backend_pvtsubnet1"
  }
}

# Create private subnet4
resource "aws_subnet" "private4" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "backend_pvtsubnet2"
  }
}

# Create private subnet5
resource "aws_subnet" "private5" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "rds_replicasubnet"
  }
}

# Create private subnet6
resource "aws_subnet" "private6" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "ap-southeast-1c"
  tags = {
    name = "rds_pvtsubnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "net" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "singapore_IG"
  }
}

# Public route table
resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.name.id
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
  vpc_id = aws_vpc.name.id
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

resource "aws_route_table_association" "private3_assoc" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private4_assoc" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private5_assoc" {
  subnet_id      = aws_subnet.private5.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private6_assoc" {
  subnet_id      = aws_subnet.private6.id
  route_table_id = aws_route_table.private.id
}

# Security group for bastion host
resource "aws_security_group" "frontend_sg" {
  name        = "frontend"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.name.id

  ingress {
    description = "SSH from anywhere (be restrictive in real use)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere (be restrictive in real use)"
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
    Name = "frontend"
  }
}

# Security group for backend
resource "aws_security_group" "backend_sg" {
  name        = "backend"
  description = "Allow http access"
  vpc_id      = aws_vpc.name.id

  ingress {
    description     = "http from anywhere (be restrictive in real use)"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description     = "Allow HTTPS from frontend"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend"
  }
}

# Security group for rds
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access from backend"
  vpc_id      = aws_vpc.name.id

  ingress {
    description     = "MySQL from backend SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

