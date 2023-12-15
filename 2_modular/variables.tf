variable "aws_region" {
  description = "AWS Region"
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for main vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "namespace" {
  description = "Namespace for resource names"
  default     = "vortexwest"
  type        = string
}

variable "public_ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
  default = "publicsshkey"
}

variable "autoscaling_max_size" {
  description = "Max size of the autoscaling group"
  default     = 4
  type        = number
}

variable "autoscaling_min_size" {
  description = "Min size of the autoscaling group"
  default     = 2
  type        = number
}

### General Variables ###
variable "root_domain_name" {
  type        = string
  description = "The domain name for the website."
  default     = "www.example.info"
}

variable "r53_zone_id" {
  type        = string
  description = "The zone ID of the domain you are deploying to, you can get it from R53 DNS Dashboard"
  default     = "Z002051618M4QHG4VM3M6"
}
