provider "aws" {
  region = local.region
}

locals {
  name     = "${basename(path.cwd)}-${var.namespace}-${var.environment}"
  region   = var.aws_region
  vpc_cidr = var.vpc_cidr_block
  # environment = var.environment
  # namespace = var.namespace
  domain_name = "${var.namespace}-${var.environment}.${var.root_domain_name}"
}

##################
# S3 State File          # "terraform init" with either the "-reconfigure" or "-migrate-state"
##################

# terraform {
#   backend "s3" {
#     encrypt              = true
#     bucket               = "rackep-vw-buckets"
#     dynamodb_table       = aws_dynamodb_table.dynamodb_terraform_state_lock.name
#     key                  = "terraform.tfstate"
#     region               = "eu-north-1"
#     workspace_key_prefix = "workspaces"
#   }
# }

# resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
#   name           = "terraform-state-lock-dynamo-${var.environment}"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

##################
# Modules
##################
module "networking" {
  source      = "./networking"
  environment = var.environment
  namespace   = var.namespace
}

module "compute" {
  source               = "./compute"
  vpc                  = module.networking.vpc
  sg_private           = module.networking.sg_private
  sg_public            = module.networking.sg_public
  sg_alb               = module.networking.sg_alb
  public_ec2_key       = var.public_ec2_key
  autoscaling_min_size = var.autoscaling_min_size
  autoscaling_max_size = var.autoscaling_max_size
  r53_zone_id          = var.r53_zone_id
  environment          = var.environment
  namespace            = var.namespace
  domain_name          = local.domain_name
}

module "rds" {
  source                     = "./rds"
  vpc                        = module.networking.vpc
  environment                = var.environment
  namespace                  = var.namespace
  sg_db                      = module.networking.sg_db
  database_subnet_group_name = module.networking.vpc.database_subnet_group_name
  db_username                = var.db_username
  db_password                = var.db_password
}
