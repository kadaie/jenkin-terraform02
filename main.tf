terraform {
  backend "s3" {
    bucket = "terracode"
    key    = "kd-state/main.tfstate"
    region = "us-east-1"
  }
}
module "kd_vpc" {
  source                    = "./kd_modules/kd_vpc"
  env_prefix                = var.env_prefix
  avail_zone_1a             = var.avail_zone_1a
  avail_zone_1b             = var.avail_zone_1b
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block

}
module "kd_ecr" {
  source = "./kd_modules/kd_ecr"
  image_tag_mutability = var.image_tag_mutability
  env_prefix = var.env_prefix
}
module "kd_ecs" {
  source = "./kd_modules/kd_ecs"
  env_prefix = var.env_prefix
  ecs_subnet_1 = module.kd_vpc.private_subnet_1.id
  ecs_subnet_2 = module.kd_vpc.private_subnet_2.id
  vpc_id = module.kd_vpc.vpc.id
  container_definitions = var.container_definitions
  container_name = var.container_name
  container_port = var.container_port
  alb_target_group_arn = module.kd_alb.alb_tg.arn
  depends_on = [ module.kd_rds ]
}
module "kd_alb" {
  source = "./kd_modules/kd_alb"
  vpc_id = module.kd_vpc.vpc.id
  public_subnet_1 = module.kd_vpc.public_subnet_1.id
  public_subnet_2 = module.kd_vpc.public_subnet_2.id
  env_prefix = var.env_prefix
}
# module "kd_instance" {
#   source        = "./kd_modules/kd_instance"
#   env_prefix    = var.env_prefix
#   instance_name = element(var.instance_name, count.index)
#   instance_type = element(var.instance_type, count.index)
#   ami           = var.ami
#   pub_key_file  = var.pub_key_file
#   user_data     = element(var.user_data, count.index)
#   avail_zone    = var.avail_zone_1a
#   subnet_id     = module.kd_vpc.public_subnet_1.id
#   vpc_id        = module.kd_vpc.vpc.id
#   count = 2
# }
module "kd_rds" {
  source                = "./kd_modules/kd_rds"
  env_prefix            = var.env_prefix
  db_instance_name      = var.db_instance_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_name               = var.db_name
  allocated_storage     = var.allocated_storage
  instance_class        = var.instance_class
  max_allocated_storage = var.max_allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  vpc_id                = module.kd_vpc.vpc.id
  avail_zone            = var.avail_zone_1a
  db_subnet_1           = module.kd_vpc.private_subnet_1.id
  db_subnet_2           = module.kd_vpc.private_subnet_2.id
}