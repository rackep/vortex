output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc" {
  value = module.vpc
}

output "sg_private" {
  description = "Private Security Group IDs"
  value       = aws_security_group.sg_private.id
}

output "sg_alb" {
  description = "ALB Security Group IDs"
  value       = aws_security_group.sg_alb.id
}

output "sg_public" {
  description = "Public Security Group IDs"
  value       = aws_security_group.sg_public.id
}
