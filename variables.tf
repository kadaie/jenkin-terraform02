variable "env_prefix" {}
variable "avail_zone_1a" {}
variable "avail_zone_1b" {}
variable "vpc_cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "private_subnet_cidr_block" {}
variable "ami" {}
variable "pub_key_file" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "allocated_storage" {}
variable "instance_class" {}
variable "max_allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "db_instance_name" {}
variable "image_tag_mutability" {}
variable "container_definitions" {}
variable "container_name" {}
variable "container_port" {}
variable "instance_name" {
  type=list(string)
  default = [
    "jenkins-master",
    "jenkins-agent"
  ]
}
variable "instance_type" {
  type=list(string)
  default = [
    "t2.micro",
    "t3.small"
  ]
}
variable "user_data" {
  type=list(string)
  default = [
    "./instance_user_data/jenkins_master.yaml",
    "./instance_user_data/jenkins_agent.yaml"
  ]
}