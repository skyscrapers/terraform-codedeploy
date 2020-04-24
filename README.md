Terraform modules that are related to codedeploy

# app
Create a codedeploy app

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of your codedeploy application | `any` | n/a | yes |
| project | The current project | `any` | n/a | yes |
| s3_bucket_arn | ARN of the S3 bucket where to fetch the application revision packages | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| app_name | n/a |
| deployer_policy_arn | n/a |
| deployer_policy_id | n/a |
| deployer_policy_name | n/a |

## Example
```
  module "codedeploy" {
    source  = "github.com/skyscrapers/terraform-codedeploy//app"
    name    = "application"
    project = "example"
  }
```

# deployment-group
Create an deployment group for a codedeploy app

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name | Name of the app | `any` | n/a | yes |
| autoscaling_groups | Autoscaling groups you want to attach to the deployment group | `list(string)` | n/a | yes |
| environment | Environment where your codedeploy deployment group is used for | `any` | n/a | yes |
| service_role_arn | IAM role that is used by the deployment group | `any` | n/a | yes |
| alb_target_group | Name of the ALB target group to use, define it when traffic need to be blocked from ALB during deployment | `string` | `null` | no |
| blue_termination_behavior | The action to take on instances in the original environment after a successful deployment. Only relevant when `enable_bluegreen` is `true` | `string` | `"KEEP_ALIVE"` | no |
| bluegreen_timeout_action | When to reroute traffic from an original environment to a replacement environment. Only relevant when `enable_bluegreen` is `true` | `string` | `"CONTINUE_DEPLOYMENT"` | no |
| ec2_tag_filter | Filter key and value you want to use for tags filters. Defined as key/value format, example: `{"Environment":"staging"}` | `map(string)` | `null` | no |
| enable_bluegreen | Enable all bluegreen deployment options | `bool` | `false` | no |
| green_provisioning | The method used to add instances to a replacement environment. Only relevant when `enable_bluegreen` is `true` | `string` | `"COPY_AUTO_SCALING_GROUP"` | no |
| rollback_enabled | Whether to enable auto rollback | `bool` | `false` | no |
| rollback_events | The event types that trigger a rollback | `list(string)` | <pre>[<br>  "DEPLOYMENT_FAILURE"<br>]</pre> | no |
| trigger_events | events that can trigger the notifications | `list(string)` | <pre>[<br>  "DeploymentStop",<br>  "DeploymentRollback",<br>  "DeploymentSuccess",<br>  "DeploymentFailure",<br>  "DeploymentStart"<br>]</pre> | no |
| trigger_target_arn | The ARN of the SNS topic through which notifications are sent | `string` | `null` | no |

## Outputs

No output.


## Example
```
  module "deployment_group" {
    source             = "github.com/skyscrapers/terraform-codedeploy//deployment-group"
    environment        = "production"
    app_name           = module.codedeploy.app_name
    service_role_arn   = module.iam.arn_role
    autoscaling_groups = ["autoscaling1", "autoscaling2"]
  }
```


# S3 bucket

Create an S3 bucket to use with Codedeploy, to store application revisions.
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for the bucket name. Note that the same bucket is used for all codedeploy deployment groups | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn | n/a |
| bucket_id | n/a |
| policy_arn | n/a |
| policy_id | n/a |
| policy_name | n/a |

## Example

```
module "codedeploy_bucket" {
  source      = "github.com/skyscrapers/terraform-codedeploy//s3bucket?ref=478373f6f8d4a46b7a1ec96090707365e0ae3e42"
  name_prefix = "app"
}
```

# notify-slack
Creates a lambda function that notifies Slack via the [incoming webhooks](https://skyscrapers.slack.com/apps/A0F7XDUAZ-incoming-webhooks) when a deployment event happens using an SNS topic to call the lambda function.


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kms_key_arn | KMS used for encrypting the webhook | `any` | n/a | yes |
| slack_channel | E.g. #channel_name | `any` | n/a | yes |
| slack_webhook_url | Needs to be encrypted from a file with _no_ encryption context, using: aws kms encrypt --key-id 'arn:' --plaintext 'fileb://webhook' --output text --query CiphertextBlob | `any` | n/a | yes |
| notify_users | Slack usernames for mentions as a space separated string as '<@name1> <@name2>' or '<!channel>' or '<!here>' | `string` | `""` | no |
| verbose | All codedeploy messages will be output if true. Only CREATED, FAILED, STOPPED and SUCCEEDED if it is empty or false | `string` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns_topic | n/a |


## Example
```
  module "slack-notification" {
    source  = "github.com/skyscrapers/terraform-codedeploy//notify-slack"
    slack_webhook_url = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    slack_channel = "#channel_name"
    kms_key_arn = aws_kms_key.kms_key.arn
  }
```

