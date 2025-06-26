resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.type
  key_name      = var.key

  tags = {
    Name = "terraform-ec2"
  }
}
