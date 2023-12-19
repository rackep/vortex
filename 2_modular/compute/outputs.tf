# output "public_ip" {
#   value = aws_instance.ec2_public.public_ip
# }

# output "ec2_public" {
#   value = aws_instance.ec2_public
# }

# output "instance_ids_one" {
#   description = "Public Security Group IDs"
#   value       = data.aws_instances.ecs_instances.ids
# }

output "alb_dns" {
  value = aws_alb.alb.dns_name
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.service_target_group.arn
}
