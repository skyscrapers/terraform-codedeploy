from __future__ import print_function
import json,urllib2,urllib
import os, boto3
from base64 import b64decode
import sys
import traceback
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def decrypt(in_message):
    """
    Decrypts the message with kms
    AWS lamda SNS test is not valid json at 13-03-18
    """
    region = os.environ['AWS_DEFAULT_REGION']
    try:
        kms = boto3.client('kms', region_name=region)
        return kms.decrypt(CiphertextBlob=b64decode(in_message))['Plaintext']
    except:
        logger.error(''.join(traceback.format_exception(sys.exc_info())))


def send_slack(message):
    """
    Send Slack Message to Deployments Channel
    """
    slack_url = decrypt(os.environ['SLACK_WEBHOOK'])
    slack_channel = os.environ['SLACK_CHANNEL']
    text = "%s deployment for app %s in group %s with id %s" % (message['status'], message['applicationName'], message['deploymentGroupName'], message['deploymentId'])
    payload = {
        "channel": slack_channel,
        "username": "codedeploy",
        "text": text
    }

    data = urllib.urlencode({"payload":json.dumps(payload)})
    req = urllib2.Request(slack_url, data)
    response = urllib2.urlopen(req)

def lambda_handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    send_slack(message)
    return message
