output "alb_tg" {
  value = aws_lb_target_group.alb-tg
}
output "ecs_service_alb" {
    value = aws_lb.alb
  
}