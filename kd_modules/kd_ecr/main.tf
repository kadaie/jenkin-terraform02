resource "aws_ecr_repository" "ecr" {
  name = "${var.env_prefix}-ecr"
  image_tag_mutability = var.image_tag_mutability 
}