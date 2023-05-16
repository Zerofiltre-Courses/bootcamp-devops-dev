output "ec2_instance_ids" {
  //value       = module.ec2_instance.instance_id
  value       = [for instance in module.ec2_instance : instance.instance_ids]
  description = "ID de l'instance EC2 créée"
}

output "ec2_public_ips" {
  //value       = module.ec2_instance.public_ip
  value       = [for instance in module.ec2_instance : instance.public_ips]
  description = "Adresse IP publique de l'instance EC2"
}
