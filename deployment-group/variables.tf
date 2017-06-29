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
  type        = "list"
  description = "Autoscaling groups you want to attach to the deployment group"
}

variable "rollback_enabled" {
  description = "Whether to enable auto rollback"
  default     = false
}

variable "rollback_events" {
  description = "The event types that trigger a rollback"
  type        = "list"
  default     = ["DEPLOYMENT_FAILURE"]
}
