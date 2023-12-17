provider "aws" {
  region = local.region
}


data "aws_availability_zones" "available" {}

locals {

  #   subnet_count = length(data.aws_availability_zones.available.names) # prvi nacin
  azs = slice(data.aws_availability_zones.available.names, 0, 3) # drugi nacin, github module example

  environment = var.environment
  name        = "${basename(path.cwd)}-west"
  region      = var.aws_region
  vpc_cidr    = var.vpc_cidr_block

  tags = {
    ProjectName = local.name
    GithubRepo  = "vortex"
    GithubOrg   = "rackep"
  }
}

##################################
# S3 Backend for State File
##################################

### S3 run before everything
# resource "aws_s3_bucket" "tf_course" {

#   bucket = "rackep-vw-buckets"
#   tags = {
#     Name        = "rackep-vw-buckets"
#   }

# }

terraform {
  backend "s3" {
    encrypt              = true
    bucket               = "rackep-vw-buckets"
    dynamodb_table       = aws_dynamodb_table.dynamodb_terraform_state_lock.name
    key                  = "terraform.tfstate"
    region               = "eu-north-1"
    workspace_key_prefix = "workspaces"
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "terraform-state-lock-dynamo-${local.environment}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  #   azs = data.aws_availability_zones.available.names # prvi nacin
  enable_nat_gateway           = false # true
  single_nat_gateway           = false # true
  create_database_subnet_group = false # pada ako se stavi na true https://github.com/terraform-aws-modules/terraform-aws-rds/issues/327

  #   database_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 8, i)] # prvi nacin
  #   private_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 8, i + 3)] # prvi nacin
  #   public_subnets = [for i in range(local.subnet_count): cidrsubnet(var.vpc_cidr_block, 8, i + 6)] # prvi nacin

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  #private_subnet_names = ["Private Subnet One", "Private Subnet Two"]

  tags = local.tags
}
