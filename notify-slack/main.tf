resource "aws_iam_role" "iam_for_lambda" {
  name = "default_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cd_sns_lambda_policy" {
  name = "cd_sns-lambda-policy"
  role = "${aws_iam_role.iam_for_lambda.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "kms:Decrypt"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_sns_topic" "cd-sns-lambda" {
    name = "cd-sns-lambda"
}

resource "aws_sns_topic_subscription" "lambda-subscription" {
    topic_arn = "${aws_sns_topic.cd-sns-lambda.arn}"
    protocol = "lambda"
    endpoint = "${aws_lambda_function.cd_sns_lambda.arn}"
}

resource "aws_lambda_function" "cd_sns_lambda" {
  function_name     = "cd_sns_lambda"
  role              = "${aws_iam_role.iam_for_lambda.arn}"
  handler           = "lambda-slack.lambda_handler"
  filename          = "${path.module}/functions/lambda-slack.zip"
  source_code_hash = "${base64sha256(file("${path.module}/functions/lambda-slack.zip"))}"
  runtime           = "python2.7"
  timeout           = "120"
  kms_key_arn       = "${var.kms_key_arn}"
  environment {
    variables = {
      SLACK_WEBHOOK = "${var.slack_webhook_url}"
      SLACK_CHANNEL = "${var.slack_channel}"
    }
  }
}

resource "aws_lambda_permission" "cd_sns_lambda" {
  statement_id   = "AllowExecutionFromSNS"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.cd_sns_lambda.function_name}"
  principal      = "sns.amazonaws.com"
  source_arn     = "${aws_sns_topic.cd-sns-lambda.arn}"
}
