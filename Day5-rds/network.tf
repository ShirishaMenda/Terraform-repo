resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "rds-vpc"
  }
}

# Create private subnet1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "private_subnet1"
  }
}

# Create private subnet2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "private_subnet2"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-private-sg"
  description = "Allow DB traffic from app servers only"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "MySQL from app servers"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # adjust to your app server CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
