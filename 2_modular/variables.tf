######################
# General
######################

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "namespace" {
  description = "Namespace for resource names"
  default     = "vortexwest"
  type        = string
}

####################
# VPC
####################
variable "vpc_cidr_block" {
  description = "CIDR block for main vpc"
  type        = string
  default     = "10.0.0.0/16"
}



variable "public_ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
  default     = "publicsshkey"
}

####################
# COMPUTE
####################
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

######################
# ROUTE 53
######################
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

#################
# RDS
#################

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}


##################
# ECS
##################

variable "maximum_scaling_step_size" {
  description = "Maximum amount of EC2 instances that should be added on scale-out"
  default     = 4
  type        = number
}

variable "minimum_scaling_step_size" {
  description = "Minimum amount of EC2 instances that should be added on scale-out"
  default     = 1
  type        = number
}

variable "target_capacity" {
  description = "Amount of resources of container instances that should be used for task placement in %"
  default     = 100
  type        = number
}

# Task definition
variable "frontend_container_image" {
  description = "Frontend Container Image"
  type        = string
}

variable "backend_container_image" {
  description = "Backend Container Image"
  type        = string
}

variable "postgres_host" {
  description = "Backend Container Image"
  type        = string
}
