resource "aws_db_instance" "wy_rds" {
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  availability_zone      = var.avail_zone
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  identifier             = "${var.env_prefix}-${var.db_instance_name}"
  multi_az               = false
  skip_final_snapshot    = true
  storage_type           = var.storage_type
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.env_prefix}-${var.db_instance_name}-db-subnet-group"
  subnet_ids = [var.db_subnet_1, var.db_subnet_2]

  tags = {
    Name = "${var.env_prefix}-${var.db_instance_name}-db-subnet-group"
  }
}
resource "aws_security_group" "db_sg" {
  name        = "${var.env_prefix}-${var.db_instance_name}-sg"
  description = "Allow sql"
  vpc_id      = var.vpc_id
  ingress {
    description = "allow mysql db"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-${var.db_instance_name}-sg"
  }
}