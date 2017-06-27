variable "environment" {
  description = "Environment where your codedeploy deployment group is used for"
}

variable "app_name" {
  description = "Name of the app"
}

variable "service_role_arn" {
  description = "IAM role that is used by the deployment group"
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

variable "filterkey" {
  description = "filter key you want to use for filtering"
}

variable "filtervalue" {
  description = "filter value you want to use for filtering"
}

variable "trigger_arn" {
  description = "SNS topic through which notifications are sent."
}

variable "trigger_name" {
  description = "the name of the notification trigger"
}

variable "trigger_events" {
  description = "events that can trigger the notifications"
  type = "list"
  default = ["DeploymentStop" , "DeploymentRollback" ,"DeploymentSuccess" ,"DeploymentFailure" ,"DeploymentStart"]
}
