variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "security_group" {}
variable "tags" {
  type    = map(string)
  default = {}
}
