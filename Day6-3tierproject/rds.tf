#create rds-subnetgroup
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private5.id, aws_subnet.private6.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

#create rds
resource "aws_db_instance" "mydb" {
  identifier             = "mydb-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username               = var.rds-username
  password               = var.rds-password
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "mydb-instance"
  }
}


