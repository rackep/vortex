locals {
  name = "${var.namespace}-${var.environment}-PostgresDB"
}

resource "aws_db_instance" "postgres" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "16.1"
  identifier        = lower(local.name)
  instance_class    = "db.t3.micro"
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  port              = 5432

  db_subnet_group_name   = var.database_subnet_group_name
  vpc_security_group_ids = [var.sg_db]

  # parameter_group_name   = "default.postgres16"
  publicly_accessible = false
  skip_final_snapshot = true


  tags = {
    Name = local.name
  }
}
