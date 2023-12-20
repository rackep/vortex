########################################################################################################################
## Creates ECS Task Definition
########################################################################################################################

resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}_ECS_TaskDefinition_${var.environment}"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_iam_role.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      "name" : "frontend",
      "image" : var.frontend_container_image,
      # "cpu" : 256,
      # "memoryReservation" : 512,
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
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "${var.namespace}-log-stream-${var.environment}"
        }
      },
      "healthCheck" : {
        "command" : [
          "CMD-SHELL",
          "curl -f http://localhost/ || exit 1"
        ],
        "interval" : 30,
        "timeout" : 5,
        "retries" : 3
      },
      "environment" : [
        {
          "name" : "NGINX_HOST",
          "value" : "frontend"
        },
      ]
    },
    {
      "name" : "backend",
      "image" : var.backend_container_image,
      # "cpu" : 256,
      # "memory" : 512,
      "essential" : false,
      "portMappings" : [
        {
          "name" : "8000",
          "containerPort" : 8000,
          "hostPort" : 8000,
          "protocol" : "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "${var.namespace}-log-stream-${var.environment}"
        }
      },
      "command" : [
        "sh",
        "-c",
        "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
      ],
      "environment" : [
        {
          "name" : "POSTGRES_HOST",
          "value" : replace(var.rds_endpoint, ":5432", "") # "vortexwest-dev-postgresdb.c8kyovqj38f0.eu-north-1.rds.amazonaws.com" # "db" endpoint
        },
        {
          "name" : "POSTGRES_USER",
          "value" : var.db_username # "postgres"
        },
        {
          "name" : "POSTGRES_PASSWORD",
          "value" : var.db_password # "00000000"
        },
        {
          "name" : "POSTGRES_PORT",
          "value" : "5432"
        },
        {
          "name" : "POSTGRES_DB",
          "value" : var.db_name # "postgres"
        },
      ]
    }
  ])
}
