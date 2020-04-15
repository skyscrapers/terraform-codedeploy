variable "environment" {
  description = "Environment where your codedeploy deployment group is used for"
}

variable "app_name" {
  description = "Name of the app"
}

variable "service_role_arn" {
  description = "IAM role that is used by the deployment group"
}

variable "autoscaling_groups" {
  type        = list(string)
  description = "Autoscaling groups you want to attach to the deployment group"
}

variable "rollback_enabled" {
  description = "Whether to enable auto rollback"
  default     = false
}

variable "rollback_events" {
  description = "The event types that trigger a rollback"
  type        = list(string)
  default     = ["DEPLOYMENT_FAILURE"]
}

variable "trigger_events" {
  description = "events that can trigger the notifications"
  type        = list(string)
  default     = ["DeploymentStop", "DeploymentRollback", "DeploymentSuccess", "DeploymentFailure", "DeploymentStart"]
}

variable "trigger_target_arn" {
  description = "The ARN of the SNS topic through which notifications are sent"
  type        = string
  default     = null
}

variable "bluegreen_config" {
  description = ""
  type        = map(string)
  default     = null

}


variable "alb_target_group" {
  description = "Name of the ALB target group, to be used with blue/green deployment group"
  default     = null
  type        = string
}

variable "ec2_tag_filter" {
  type    = map(string)
  default = null
}