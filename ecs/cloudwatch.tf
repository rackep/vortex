####################################
## Create log group for service
####################################

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${lower(var.namespace)}/ecs/${var.namespace}"
  retention_in_days = 30


}
