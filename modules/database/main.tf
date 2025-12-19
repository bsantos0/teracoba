#1. generate password database acak
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#2. membuat security group database
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#3. membuat temapt subnet database
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

#4. membuat databse RDS MySQL
resource "aws_db_instance" "web-db" {   
  identifier         = "${var.project_name}-db-instance"
  allocated_storage  = 10
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  username           = var.db_username
  password           = random_password.db_password.result
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = true
  tags = {
    Name = "${var.project_name}-db-instance"
  }
  
}

output "db_endpoint" {
  value = aws_db_instance.web-db.endpoint  
}

output "db_password" {
  value = random_password.db_password.result
  sensitive = true
}