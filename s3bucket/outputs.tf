output "bucket_id" {
  value = aws_s3_bucket.codedeploy_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.codedeploy_bucket.arn
}

output "policy_id" {
  value = aws_iam_policy.codedeploy_policy.id
}

output "policy_arn" {
  value = aws_iam_policy.codedeploy_policy.arn
}

output "policy_name" {
  value = aws_iam_policy.codedeploy_policy.name
}

