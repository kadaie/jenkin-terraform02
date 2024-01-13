resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_prefix}-ecs-cluster"
  tags = {
    Name = "${var.env_prefix}-ecs-cluster"
  }
}
resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.env_prefix}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = [var.ecs_subnet_1, var.ecs_subnet_2]
    security_groups = [aws_security_group.ecr_sg.id]
  }
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.env_prefix}-ecs-task-definition"
  requires_compatibilities = ["FARGATE", "EC2"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::339586505000:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::339586505000:role/ecsTaskExecutionRole"
  container_definitions    = file(var.container_definitions)
}
resource "aws_security_group" "ecr_sg" {
  name        = "${var.env_prefix}-${aws_ecs_task_definition.ecs_task_definition.family}-ecr_sg"
  description = "Allow http"
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
    Name = "${var.env_prefix}-${aws_ecs_task_definition.ecs_task_definition.family}-ecr_sg"
  }
}
