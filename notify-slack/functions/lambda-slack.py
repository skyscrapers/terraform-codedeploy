from __future__ import print_function
import json,urllib2,urllib
import os, boto3
from base64 import b64decode
import re
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


def send_slack(message, subject):
    """
    Send Slack Message to Deployments Channel
    """
    severity_level = "good"
    icon_emoji = ":codedeploy:"
    slack_url = decrypt(os.environ['SLACK_WEBHOOK'])
    slack_channel = os.environ['SLACK_CHANNEL']
    notify_users = os.environ['NOTIFY_USERS']

    text = "%s deployment for app %s in group %s with id %s" % (message['status'], message['applicationName'], 
    message['deploymentGroupName'], message['deploymentId'])

    matchObj = re.match( r'fail', message['status'], re.I) # Check for FAILED state
    if matchObj :
      severity_level = "danger"
      if notify_users == "" :
        text = '*FAILED* ' + text
      else :
        text = notify_users + ' - '  + text

    matchObj = re.match(r'stop', message['status'], re.I) # Check for STOPPED state
    if matchObj :
        severity_level = "warning"
        text = '*STOPPED* ' + text

    payload = {
        "channel": slack_channel,
        "username": "codedeploy",
        "title": subject,
        "colour": severity_level,
        "fallback": text,
        "icon_emoji": icon_emoji
    }

    data = urllib.urlencode({"payload":json.dumps(payload)})
    req = urllib2.Request(slack_url, data)
    response = urllib2.urlopen(req)

def lambda_handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    subject = json.loads(event['Records'][0]['Sns']['Subject'])
    # Verbose outputs all messages, otherwise only 
    if os.environ['VERBOSE'] :
      send_slack(message, subject)
    elif message['status'] == 'START' or message['status'] == 'STOPPED' or message['status'] == 'FAILED' or message['status'] == 'SUCCEEDED':
        send_slack(message, subject)
    else :
        send_slack(message, subject)

    return subject + ' ' + message
