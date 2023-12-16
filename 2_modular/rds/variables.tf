variable "environment" {
  type    = string
  default = ""
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
  default     = ""
}

variable "database_subnet_group_name" {
  type = string
}

variable "sg_db" {
  type = string
}

variable "vpc" {
  type = any
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
