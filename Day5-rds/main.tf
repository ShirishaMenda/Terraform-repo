resource "aws_db_subnet_group" "default" {
  name       = "private-rds-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "private-rds-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "singaporedb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.usernamerds
  password             = var.passwordrds
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = false

}