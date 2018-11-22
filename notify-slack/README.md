# notify-slack

## Encrypting the webhook

The Slack webhook needs to be encrypted with KMS.
It has to be in a file and not simply as a string e.g. `--plaintext 'https://...'` as KMS will try to resolve it as a resource.

`aws kms encrypt --key-id "alias/keyName" --plaintext 'fileb://webhook' --output text --query CiphertextBlob`

## on CodeDeploy failures

- [notify_users]: String (optional) It is possible to use mentions on failues. This is a simple string, e.g. "<@name1> <@name2>" or if the customer requests it, it can simply be "<!channel>" or "<!here>".

## Testing

To test that the lamda code is working, you can publish to the topic from the AWS CLI, setting the SNS ARN for the below command.
Please note that currently the built in AWS Lamda test for SNS does not supply a correct JSON formatted message.

`aws sns publish --topic-arn arn:...:cd-sns-lambda --message '{"applicationName": "test-slack-notify", "deploymentId": "d-12A3BCDEF", "deploymentGroupName": "dep-group-def-123", "status": "succeeded"}'`
