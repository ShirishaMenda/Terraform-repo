resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "sinapore_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.network.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "sinapore_publicsubnet"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = "sinapore_IG"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
    Name = "sinapore_RT_public"
  }
}

resource "aws_route_table_association" "singapore" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = aws_vpc.network.id
  tags = {
    Name = "singapore_sg"
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


