resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = var.app_name
  deployment_group_name  = "${var.app_name}-${var.environment}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  service_role_arn       = var.service_role_arn
  autoscaling_groups     = var.autoscaling_groups

  auto_rollback_configuration {
    enabled = var.rollback_enabled
    events  = var.rollback_events
  }
  dynamic "load_balancer_info" {
    for_each = var.alb_target_group == null ? [] : [var.alb_target_group]
    content {
      target_group_info {
        name = var.alb_target_group
      }
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = var.action_on_timeout
    }

    terminate_blue_instances_on_deployment_success {
      action = var.terminate_blue_instances_on_deployment_success
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  trigger_configuration {
    trigger_events     = var.trigger_events
    trigger_name       = "${var.app_name}-${var.environment}"
    trigger_target_arn = var.trigger_target_arn
  }
}

