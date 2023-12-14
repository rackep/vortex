provider "aws" {
  region = local.region
}

locals {
  name   = "${basename(path.cwd)}-west"
  region = var.aws_region
  vpc_cidr = var.vpc_cidr_block
  environment = var.environment
  namespace = var.namespace
}

module "networking" {
  source    = "./networking"
}

module "compute" {
  source     = "./compute"
  vpc        = module.networking.vpc
  sg_private = module.networking.sg_private
  sg_public = module.networking.sg_public
  sg_alb = module.networking.sg_alb
  public_ec2_key = var.public_ec2_key
  autoscaling_min_size = var.autoscaling_min_size
  autoscaling_max_size = var.autoscaling_max_size
  r53_zone_id = var.r53_zone_id
  domain_name = var.domain_name
}