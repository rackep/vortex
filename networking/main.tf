provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  environment = var.environment
  name        = "${basename(path.cwd)}-${var.namespace}-${var.environment}"
  region      = var.aws_region
  vpc_cidr    = var.vpc_cidr_block

  tags = {
    ProjectName = local.name
    GithubRepo  = "vortex"
    GithubOrg   = "rackep"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  enable_dns_support   = true # Should be true to enable DNS support in the VPC
  enable_dns_hostnames = true # Should be true to enable DNS hostnames in the VPC

  enable_nat_gateway = true
  single_nat_gateway = true

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

  create_database_subnet_group = true
  database_subnet_group_name   = "database_subnets"

  tags = local.tags
}

################################################################################
# Security Groups
################################################################################


### ALB SG
resource "aws_security_group" "sg_alb" {
  name        = "ALB Security Group"
  description = "ALB Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group ${var.environment}"
  }

}

### Public SG
resource "aws_security_group" "sg_public" {
  name        = "Public Security Group"
  description = "Public Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Subnet Security Group ${var.environment}"
  }

}

### Private SG
resource "aws_security_group" "sg_private" {
  name        = "Private Security Group"
  description = "Private Security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Subnet Security Group ${var.environment}"
  }

}

### DB SG
resource "aws_security_group" "sg_db" {
  name        = "DB Security Group"
  description = "DB Security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group ${var.environment}"
  }

}

##############
# RULES
##############

# HTTP to Private
resource "aws_security_group_rule" "http_public" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_alb.id
}

# HTTPS to Private
resource "aws_security_group_rule" "https_public" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_alb.id
}

# 8000 to Private
resource "aws_security_group_rule" "backend_private" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_alb.id
}


# postgress ruless
resource "aws_security_group_rule" "db_egress" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_db.id
}

resource "aws_security_group_rule" "priv_in_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_db.id
}
resource "aws_security_group_rule" "db_ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_db.id
  source_security_group_id = aws_security_group.sg_private.id
}
