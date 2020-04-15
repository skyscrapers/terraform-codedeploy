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

variable "enable_bluegreen" {
  description = "Enable all bluegreen deployment options"
  type        = bool
  default     = false

}

variable "bluegreen_timeout_action" {
  description = "When to reroute traffic from an original environment to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "CONTINUE_DEPLOYMENT"
}

variable "blue_termination_behavior" {
  description = " The action to take on instances in the original environment after a successful deployment. Only relevant when `enable_bluegreen` is `true`"
  default     = "KEEP_ALIVE"
}

variable "green_provisioning" {
  description = "The method used to add instances to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "COPY_AUTO_SCALING_GROUP"


}

variable "alb_target_group" {
  description = "Name of the ALB target group to use, define it when traffic need to be blocked from ALB during deployment"
  default     = null
  type        = string
}

variable "ec2_tag_filter" {
  description = "Filter key and value you want to use for tags filters. Defined as key/value format, example: `{\"Environment\":\"staging\"}`"
  type        = map(string)
  default     = null
}
