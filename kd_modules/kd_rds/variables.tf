variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "allocated_storage" {}
variable "instance_class" {}
variable "max_allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "db_instance_name" {}
variable "env_prefix" {}
variable "vpc_id" {}
variable "avail_zone" {}
variable "db_subnet_1" {}
variable "db_subnet_2" {}
variable "storage_type" {
  default = "gp2"
}