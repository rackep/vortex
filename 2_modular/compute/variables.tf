variable "vpc" {
  type = any
}

variable "sg_private" {
  type = string
}

variable "sg_public" {
  type = string
}

variable "sg_alb" {
  type = string
}

variable "environment" {
  type = string
}


########################################################################################################################
## Service variables
########################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "domain_name" {
  description = "Domain name of the service (like service.example.com)"
  type        = string
}

variable "r53_zone_id" {
  type        = string
  description = "The zone ID of the domain you are deploying to, you can get it from R53 DNS Dashboard"
}

########################################################################################################################
## EC2 Computing variables
########################################################################################################################

variable "public_ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t3.micro"
  type        = string
}

variable "autoscaling_max_size" {
  description = "Max size of the autoscaling group"
  type        = number
}

variable "autoscaling_min_size" {
  description = "Min size of the autoscaling group"
  type        = number
}