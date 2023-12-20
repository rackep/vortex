########################################################################################################################
## Creates ECS Service
########################################################################################################################

resource "aws_ecs_service" "service" {
  name                               = "${var.namespace}_ECS_Service_${var.environment}"
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "frontend"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.vpc.private_subnets
    security_groups  = [var.sg_private]
    assign_public_ip = false
  }

}
