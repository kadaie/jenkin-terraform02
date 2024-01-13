env_prefix = "prod"
avail_zone_1a = "us-east-1a"
avail_zone_1b = "us-east-1b"
vpc_cidr_block = "10.80.0.0/16"
public_subnet_cidr_block = ["10.80.1.0/24","10.80.2.0/24"]
private_subnet_cidr_block = ["10.80.100.0/24","10.80.200.0/24"]
ami = "ami-0c7217cdde317cfec"
pub_key_file = "~/.ssh/id_rsa.pub"
db_username = "wordpress"
db_password = "wordpress"
db_name = "wordpress"
allocated_storage = "10"
instance_class = "db.t2.micro"
max_allocated_storage = "20"
engine = "mysql"
engine_version = "8.0.35"
db_instance_name = "wordpress-db"
image_tag_mutability = "IMMUTABLE"
container_definitions = "./container-definitions/ecs_web.json"
container_name = "ecs_web"
container_port = "80"