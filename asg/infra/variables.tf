variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "aws_id" {
  type = string
}