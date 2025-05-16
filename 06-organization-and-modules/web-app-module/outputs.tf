output "instance_1_ip_addr" {
  value = aws_instance.instance_1.public_ip
}

output "instance_2_ip_addr" {
  value = aws_instance.instance_2.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.load_balancer.dns_name
}

# output "db_instance_addr" {
#   value = aws_db_instance.db_instance.address
# }
