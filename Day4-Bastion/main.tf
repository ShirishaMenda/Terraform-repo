resource "aws_instance" "bastion" {
  ami                         = "ami-0a3ece531caa5d49d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "singapore"
  tags = {
    Name = "bastionhost-public"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "private-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "private-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0a3ece531caa5d49d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = false
  key_name                    = "singapore"
  user_data                   = file("userdata.sh")
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y httpd
#     systemctl enable httpd
#     systemctl start httpd
#     mkdir -p /var/www/html
#     echo "hi" > /var/www/html/index.html
#   EOF

  tags = {
    Name = "bastionhost-private"
  }
}

