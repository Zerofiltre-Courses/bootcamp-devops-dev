terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


resource "aws_instance" "ist_server" {
  ami           =  var.ami_id
  instance_type = var.instance_type
  tags = merge(var.tags, {
    Terraform = "true"
  })
}
