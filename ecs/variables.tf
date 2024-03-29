variable "environment" {
  type    = string
  default = ""
}

variable "region" {
  type = string
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
  default     = ""
}

variable "aws_alb_target_group_arn" {
  description = "Load balancer Target Group ARN"
  type        = string
}

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

variable "frontend_container_image" {
  description = "Forntend Container Image"
  type        = string
}

variable "backend_container_image" {
  description = "Backend Container Image"
  type        = string
}

variable "vpc" {
  type = any
}

variable "sg_private" {
  type = string
}

#############
# RDS
#############
variable "rds_endpoint" {
  type = string
}

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

variable "db_name" {
  description = "Database administrator password"
  type        = string
}

