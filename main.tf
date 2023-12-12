# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true
#   tags = {
#     name = "main"
#   }
# }
# resource "aws_subnet" "subnet" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
#   map_public_ip_on_launch = true
#   availability_zone       = "eu-central-1a"
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
#   map_public_ip_on_launch = true
#   availability_zone       = "eu-central-1b"
# }

data "aws_availability_zones" "available" {}

locals {
  subnet_count = length(data.aws_availability_zones.available.names)
  my_local = var.my_variable
}

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

}