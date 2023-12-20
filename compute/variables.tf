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
  type    = string
  default = ""
}

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name of the service (like service.example.com)"
  type        = string
}

variable "r53_zone_id" {
  type        = string
  description = "The zone ID of the domain you are deploying to, you can get it from R53 DNS Dashboard"
}
