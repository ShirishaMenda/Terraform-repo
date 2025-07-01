resource "aws_instance" "bastion" {
  ami                         = "ami-0a3ece531caa5d49d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true
  key_name                    = "singapore"
  tags = {
    Name = "bastionhost-public"
  }
}

resource "aws_instance" "frontendec2" {
  ami                         = "ami-0a3ece531caa5d49d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private1.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id, aws_security_group.backend_sg.id]
  associate_public_ip_address = false
  key_name                    = "singapore"
  user_data                   = file("userdata1.sh")
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "frontendserver"
  }
}

resource "aws_instance" "backendec2" {
  ami                         = "ami-0a3ece531caa5d49d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private3.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id, aws_security_group.backend_sg.id]
  associate_public_ip_address = false
  key_name                    = "singapore"
  user_data                   = file("userdata2.sh")
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "backendserver"
  }
}

