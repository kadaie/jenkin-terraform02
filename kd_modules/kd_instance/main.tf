resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  availability_zone           = var.avail_zone
  key_name                    = "${var.env_prefix}-${var.instance_name}-key"
  user_data                   = file(var.user_data)
  tags = {
    Name = "${var.env_prefix}-${var.instance_name}"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [ tags, user_data ]
  }
}
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.env_prefix}-${var.instance_name}-key"
  public_key = file(var.pub_key_file)
  lifecycle {
    ignore_changes = [ public_key, key_name ]
  }
}
resource "aws_security_group" "sg" {
  name        = "${var.env_prefix}-${var.instance_name}-sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # description = "HTTP"
    from_port   = 8080
    to_port     = 8080
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
    Name = "${var.env_prefix}-${var.instance_name}-sg"
  }
  lifecycle {
    prevent_destroy = true
  }
}