output "instance_ids" {
  value       = aws_instance.ist_server[*].id
  description = "ID des instances EC2 créées"
}

output "public_ips" {
  value       = aws_instance.ist_server[*].public_ip
  description = "Adresses IP publiques des instances EC2"
}
