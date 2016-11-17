resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = "${var.app_name}"
  deployment_group_name = "${var.app_name}-${var.environment}"
  service_role_arn      = "${var.service_role_arn}"

  ec2_tag_filter {
    key   = "${var.filterkey}"
    type  = "KEY_AND_VALUE"
    value = "${var.filtervalue}"
  }
  ec2_tag_filter {
    key   = "environment"
    type  = "KEY_AND_VALUE"
    value = "${var.environment}"
  }
}
