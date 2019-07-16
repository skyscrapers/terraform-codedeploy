resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = var.app_name
  deployment_group_name = "${var.app_name}-${var.environment}"
  service_role_arn      = var.service_role_arn
  autoscaling_groups    = var.autoscaling_groups

  auto_rollback_configuration {
    enabled = var.rollback_enabled
    events  = var.rollback_events
  }
}

