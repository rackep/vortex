variable "aws_region" {
  description = "AWS Region"
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for main vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "my_variable" {
  type = string
  default = "Hello, world!"
}

