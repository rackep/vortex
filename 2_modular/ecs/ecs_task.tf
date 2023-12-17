########################################################################################################################
## Creates ECS Task Definition
########################################################################################################################

resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}_ECS_TaskDefinition_${var.environment}"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_iam_role.arn

  # network_mode             = "awsvpc"
  # requires_compatibilities = ["EC2"]
  # cpu                      = 512
  # runtime_platform {
  #   operating_system_family = "LINUX"
  #   cpu_architecture        = "X86_64"
  # }

  container_definitions = jsonencode([
    {
      "name" : "frontend",
      "image" : var.frontend_container_image,
      "cpu" : 256,
      "memory" : 256,
      "essential" : true,
      "portMappings" : [
        {
          "name" : "80",
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "dependsOn" : [
        {
          "containerName" : "backend",
          "condition" : "HEALTHY"
        }
      ]
    },
    {
      "name" : "backend",
      "image" : var.backend_container_image,
      "cpu" : 256,
      "memory" : 256,
      "essential" : true,
      "portMappings" : [
        {
          "name" : "8000",
          "containerPort" : 8000,
          "hostPort" : 8000,
          "protocol" : "tcp"
        }
      ],
      "command" : [
        "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
      ],
      "environment" : [
        {
          "name" : "POSTGRES_HOST",
          "value" : var.postgres_host # "db"
        }
      ],
      "healthCheck" : {
        "command" : [
          "CMD-SHELL",
          "curl -f http://localhost:8000/swagger/ || exit 1"
        ],
        "interval" : 30,
        "timeout" : 5,
        "retries" : 3
      }
    }
  ])
}

# resource "aws_cloudwatch_log_group" "log_group" {
#   name              = "/${lower(var.namespace)}/ecs/aws-ecs-ec2"
#   retention_in_days = 30

# }
