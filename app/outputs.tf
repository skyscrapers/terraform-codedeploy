output "app_name" {
  value = aws_codedeploy_app.app.name
}

output "deployer_policy_id" {
  value = aws_iam_policy.deployer_policy.id
}

output "deployer_policy_arn" {
  value = aws_iam_policy.deployer_policy.arn
}

output "deployer_policy_name" {
  value = aws_iam_policy.deployer_policy.name
}

