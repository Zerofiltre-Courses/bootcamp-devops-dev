module "ec2_instance" {
  source = "./ec2-module"
  count  = var.instance_count
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = aws_key_pair.zero_key.key_name
  subnet_id      = var.subnet_id
  security_group = [aws_security_group.zero_sg.id]
  tags           = merge(var.tags, { Name = "Instance-${count.index + 1}" })

}
resource "aws_key_pair" "zero_key" {
   key_name   = "ssh_key"
   public_key = file("~/.ssh/id_rsa.pub")
}


provider "aws" {
  region = "eu-west-3"
}
