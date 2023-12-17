########################################################################################################################
## Application Load Balancer in public subnets with HTTP default listener that redirects traffic to HTTP
########################################################################################################################

resource "aws_alb" "alb" {
  name            = "${var.namespace}-ALB-${var.environment}"
  security_groups = [var.sg_alb]
  subnets         = var.vpc.public_subnets

}

########################################################################################################################
## HTTP listener 
########################################################################################################################

resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "Access denied"
  #     status_code  = "403"
  #   }
  # }

  #  depends_on = [aws_acm_certificate.alb_certificate]
}

########################################################################################################################
## HTTPS Listener Rule to only allow traffic with a valid custom origin header coming from CloudFront
########################################################################################################################

# resource "aws_alb_listener_rule" "https_listener_rule" {
#   listener_arn = aws_alb_listener.alb_default_listener_https.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.service_target_group.arn
#   }

#   condition {
#     host_header {
#       values = ["${var.environment}.${var.domain_name}"]
#     }
#   }

#   condition {
#     http_header {
#       http_header_name = "X-Custom-Header"
#       values           = [var.custom_origin_host_header]
#     }
#   }

# }

########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.namespace}-TargetGroup-${var.environment}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc.vpc_id
  deregistration_delay = 5
  # target_type          = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    path                = "/" # var.healthcheck_endpoint  # matcher = var.healthcheck_matcher
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  depends_on = [aws_alb.alb]
}


#############

# resource "aws_lb_listener" "alb_default_listener_http" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ecs_tg.arn
#   }
# }


# resource "aws_lb_target_group" "ecs_tg" {
#   name     = "${var.namespace}-TG-${var.environment}"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc.vpc_id

#   health_check {
#     path = "/"
#   }
# }

data "aws_instances" "ecs_instances" {
  instance_tags = {
    Name = "${var.namespace}_ASG_${var.environment}"
  }

  instance_state_names = ["running"]
}

output "instance_ids" {
  value = data.aws_instances.ecs_instances.ids
}


#### Route 53 - Remove

resource "aws_route53_record" "www" {
  zone_id = var.r53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}

