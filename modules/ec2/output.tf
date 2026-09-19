output "public_ip" {
  value = aws_instance.my_ec2_instance[*].public_ip
}

output "public_dns" {
  value = aws_instance.my_ec2_instance[*].public_dns
}

# output "public_ip_second_instance" {
#   value = aws_instance.my_ec2_existing_instance[*].public_ip
# }
