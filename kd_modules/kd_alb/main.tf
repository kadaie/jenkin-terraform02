resource "aws_lb" "alb" {
  name               = "${var.env_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1, var.public_subnet_2]
}

resource "aws_lb_target_group" "alb-tg" {
  name        = "${var.env_prefix}-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}
# resource "aws_lb_target_group_attachment" "alb-tg-attachment" {
#   target_group_arn = aws_lb_target_group.alb-tg.arn
#   target_id        = aws_lb.alb.arn
#   port             = 80
# }
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}
resource "aws_security_group" "alb_sg" {
  name        = "${var.env_prefix}-alb_sg"
  description = "Allow http for alb"
  vpc_id      = var.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "${var.env_prefix}-alb_sg"
  }
}