
##################
## Networking
##################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.networking.vpc_cidr_block
}

output "vpc_name" {
  description = "VPC Name"
  #value       = module.networking.vpc
  value       = module.networking.vpc.name
}

# output "vpc_all" {
#   description = "VPC"
#   value       = module.networking.vpc
# }

output "vpc_private_subnets" {
  description = "VPC Private Subnets IDs"
  value       = module.networking.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "VPC Public Subnets IDs"
  value       = module.networking.vpc.public_subnets
}

output "sg_private_id" {
  description = "SG Private ID"
  value       = module.networking.sg_private
}

output "sg_alb_id" {
  description = "SG ALB ID"
  value       = module.networking.sg_alb
}

output "sg_public_id" {
  description = "SG ALB ID"
  value       = module.networking.sg_alb
}



##############
## Compute
##############

# output "ec2_public_ip" {
#   value = module.compute.public_ip
# }

# output "ec2_public_ami" {
#   value = module.compute.ec2_public.ami
# }

output "instance_ids" {
  description = "Public Security Group IDs"
  value       = module.compute.instance_ids
}

output "alb_dns" {
  description = "ALB DNS name"
  value       = module.compute.alb_dns
}

output "domain_name" {
  description = "Final DNS name"
  value       = local.domain_name
}
