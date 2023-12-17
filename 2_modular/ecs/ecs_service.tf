########################################################################################################################
## Creates ECS Service
########################################################################################################################

resource "aws_ecs_service" "service" {
  name                               = "${var.namespace}_ECS_Service_${var.environment}"
  iam_role                           = aws_iam_role.ecs_service_role.arn
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = 1   # var.ecs_task_desired_count
  deployment_minimum_healthy_percent = 50  # var.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = 100 # var.ecs_task_deployment_maximum_percent
  # launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn # aws_alb_target_group.service_target_group.arn
    container_name   = "frontend"
    container_port   = 80
  }

  # network_configuration {
  #   subnets          = var.vpc.private_subnets
  #   security_groups  = [var.sg_private]
  #   assign_public_ip = false
  # }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}
