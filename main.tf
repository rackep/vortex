provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {

  subnet_count = length(data.aws_availability_zones.available.names)
  my_local = var.my_variable
  name   = "${basename(path.cwd)}-west"
  region = var.aws_region

  tags = {
    Example    = local.name
    GithubRepo = "vortex"
    GithubOrg  = "rackep"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vortex-vpc"
  cidr = var.vpc_cidr_block
  azs = data.aws_availability_zones.available.names
  enable_nat_gateway = true
  single_nat_gateway = true
  create_database_subnet_group = true
  database_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 6, i)]
  private_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 6, i + local.subnet_count * 3)]
  public_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 6, i + local.subnet_count * 6)]

  tags = local.tags
}