variable "ami_id" {
  description = "ID de l'AMI à utiliser pour l'instance EC2"
  default = "ami-05b457b541faec0ca"
}

variable "instance_type" {
 description = "Type d'instance EC2"  
 default     = "t2.micro"
} 

variable "key_name" {
  description = "Nom de la paire de clés pour l'accès SSH à l'instance EC2"
  default     = "my_key_name"
}

variable "subnet_id" {
  description = "ID du subnet pour l'instance EC2"
  default     = "subnet-e4643a8d"
}

variable "security_group" {
  description = "ID du groupe de sécurité pour l'instance EC2"
  default     = "zero_sg"
}

variable "tags" {
 description = "Tags à appliquer à l'instance EC2"  
 type    = map(string)
   default = {}
}

variable "instance_count" {
  description = "Nombre d'instances EC2 à créer"
  type        = number
  default     = 3
}
