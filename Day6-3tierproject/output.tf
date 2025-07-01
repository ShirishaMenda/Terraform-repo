#create rds-endpoint
output "rds_endpont" {
  value = aws_db_instance.mydb.endpoint

}

#create frontend nd backend ald-dnsname
output "alb_dns_name_frontend" {
  value = aws_lb.frontend_alb.dns_name
}

output "alb_dns_name_backend" {
  value = aws_lb.backend_alb.dns_name
}

#create bastionhost-server public nd private ip's 
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

#create frontend-server public nd private ip's 
output "frontend_public_ip" {
  value = aws_instance.frontendec2.public_ip
}
output "frontend_private_ip" {
  value = aws_instance.frontendec2.private_ip
}

#create backend-server public nd private ip's 
output "backend_public_ip" {
  value = aws_instance.backendec2.public_ip
}
output "backend_private_ip" {
  value = aws_instance.backendec2.private_ip
}