resource "aws_iam_role" "iam_for_lambda" {
  name               = "default_lambda"
  assume_role_policy = data.aws_iam_policy_document.iam_for_lambda.json
}

data "aws_iam_policy_document" "iam_for_lambda" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cd_sns_lambda_policy" {
  name = "cd_sns-lambda-policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = data.aws_iam_policy_document.cd_sns_lambda_policy.json
}

data "aws_iam_policy_document" "cd_sns_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

resource "aws_sns_topic" "cd-sns-lambda" {
  name = "cd-sns-lambda"
}

resource "aws_sns_topic_subscription" "lambda-subscription" {
  topic_arn = aws_sns_topic.cd-sns-lambda.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.cd_sns_lambda.arn
}

data "archive_file" "slack_notification_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda-slack.zip"

  source_dir = "${path.module}/functions/"
}


resource "aws_lambda_function" "cd_sns_lambda" {
  function_name = "cd_sns_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda-slack.lambda_handler"

  filename         = "${path.module}/lambda-slack.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda-slack.zip")

  runtime     = "python2.7"
  timeout     = "120"
  kms_key_arn = var.kms_key_arn

  environment {
    variables = {
      SLACK_WEBHOOK = var.slack_webhook_url
      SLACK_CHANNEL = var.slack_channel
      NOTIFY_USERS  = var.notify_users
      VERBOSE       = var.verbose
    }
  }
}

resource "aws_lambda_permission" "cd_sns_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cd_sns_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cd-sns-lambda.arn
}
