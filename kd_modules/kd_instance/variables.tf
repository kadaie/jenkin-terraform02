variable "env_prefix" {}
variable "instance_type" {
    type = string
}
variable "ami" {}
variable "pub_key_file" {}
variable "user_data" {
    type = string
}
variable "avail_zone" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "instance_name" {
    type = string
}