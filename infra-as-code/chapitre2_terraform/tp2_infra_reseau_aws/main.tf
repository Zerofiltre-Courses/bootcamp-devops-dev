module "ec2_instance" {
  source = "./ec2-module"
  count  = var.instance_count
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  subnet_id      = var.subnet_id
  security_group = var.security_group
  tags           = merge(var.tags, { Name = "Instance-${count.index + 1}" })

}


provider "aws" {
  region = "eu-west-3"
}