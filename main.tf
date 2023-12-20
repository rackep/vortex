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
# Modules
##################
module "networking" {
  source      = "./networking"
  environment = var.environment
  namespace   = var.namespace
}

module "compute" {
  source      = "./compute"
  vpc         = module.networking.vpc
  sg_private  = module.networking.sg_private
  sg_public   = module.networking.sg_public
  sg_alb      = module.networking.sg_alb
  r53_zone_id = var.r53_zone_id
  environment = var.environment
  namespace   = var.namespace
  domain_name = local.domain_name
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
  db_name                    = var.db_name
}

module "ecs" {
  source      = "./ecs"
  vpc         = module.networking.vpc
  environment = var.environment
  namespace   = var.namespace
  # ecs_asg_arn              = module.compute.ecs_asg_arn
  aws_alb_target_group_arn = module.compute.aws_alb_target_group_arn
  frontend_container_image = var.frontend_container_image
  backend_container_image  = var.backend_container_image
  # postgres_host            = var.postgres_host
  sg_private   = module.networking.sg_private
  rds_endpoint = module.rds.rds_endpoint
  region       = local.region
  # sg_db                      = module.networking.sg_db
  # database_subnet_group_name = module.networking.vpc.database_subnet_group_name
  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name
}
