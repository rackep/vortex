output "alb_dns" {
  value = aws_alb.alb.dns_name
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.service_target_group.arn
}
