variable "environment" {
  description = "Environment where your codedeploy deployment group is used for"
}

variable "app_name" {
  description = "Name of the app"
}

variable "service_role_arn" {
  description = "IAM role that is used by the deployment group"
}

variable "filterkey" {
  description = "filter key you want to use for filtering"
}

variable "filtervalue" {
  description = "filter value you want to use for filtering"
}
