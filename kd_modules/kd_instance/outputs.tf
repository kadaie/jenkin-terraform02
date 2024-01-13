output "instance_name" {
  value = aws_instance.instance.tags.Name
}
output "public_ip" {
  value = aws_instance.instance.public_ip
}