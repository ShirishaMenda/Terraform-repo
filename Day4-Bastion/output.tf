output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "alb_dns_name" {
  value = aws_lb.public.dns_name
}
