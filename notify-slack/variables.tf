variable "slack_webhook_url" {
	description = "Needs to be encrypted from a file using: aws kms encrypt --key-id 'arn:' --plaintext 'fileb://webhook' --output text --query CiphertextBlob"
}

variable "slack_channel" {
	description = "E.g. #channel_name"
}

variable "kms_key_arn" {
	description = "KMS used for encrypting the webhook"
}

variable "notify_users" {
	description = "Slack usernames for mentions as a space separated string as '@name1 @name2'"
	type = "string"
	default = ""
}
