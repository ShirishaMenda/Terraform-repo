resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.type
  key_name                    = var.key
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  tags = {
    Name = "terraform-ec2"
  }
}