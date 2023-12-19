output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.postgres.arn, null)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.postgres.resource_id, null)
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
