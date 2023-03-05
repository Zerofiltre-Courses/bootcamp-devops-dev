terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "app_server" {
  ami           = "ami-05b457b541faec0ca"
  instance_type = "t2.micro"
  count         = 3

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
