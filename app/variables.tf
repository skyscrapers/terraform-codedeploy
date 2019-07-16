variable "name" {
  description = "Name of your codedeploy application"
}

variable "project" {
  description = "The current project"
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket where to fetch the application revision packages"
  default     = ""
}

