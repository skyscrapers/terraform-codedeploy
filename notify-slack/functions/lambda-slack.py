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


def send_slack(message):
    """
    Send Slack Message to Deployments Channel
    """
    region = os.environ['AWS_DEFAULT_REGION']
    slack_url = decrypt(os.environ['SLACK_WEBHOOK'])
    slack_channel = os.environ['SLACK_CHANNEL']
    notify_users = os.environ['NOTIFY_USERS']
    
    severity_level = "good"
    icon_emoji = ":codedeploy:"
    title = message['status']
    pretext = ""
    deployment_url = '<https://' + region + '.console.aws.amazon.com/codesuite/codedeploy/deployments/' + message['deploymentId'] + '?region=' + region + '|' + message['deploymentId'] + '>'

    text = "The deployment for app *%s* in group %s\n with id %s" % ( message['applicationName'], 
    message['deploymentGroupName'], deployment_url)

    matchObj = re.match( r'fail', message['status'], re.I) # Check for FAILED state
    if matchObj :
      severity_level = "danger"
      text = text + ' failed.'
      if notify_users != "" :
        pretext = '*' + notify_users + '*'


    matchObj = re.match(r'stop', message['status'], re.I) # Check for STOPPED state
    if matchObj :
        severity_level = "warning"
        text = text + ' stopped.'

    payload = {
      "channel": slack_channel,
      "username": "codedeploy",
      "icon_emoji": icon_emoji,
      "attachments":  [{
        "pretext": pretext,
        "title": title,
        "markdwn_in" : ["text", "pretext"],
        "color": severity_level,
        "text": text,
      }]
   }

    data = urllib.urlencode({"payload":json.dumps(payload)})
    req = urllib2.Request(slack_url, data)
    response = urllib2.urlopen(req)

def lambda_handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    
    # Verbose outputs all messages, otherwise only those set for ['status']
    if os.environ['VERBOSE'] :
      send_slack(message)
    elif message['status'] == 'CREATED' or message['status'] == 'STOPPED' or message['status'] == 'FAILED' or message['status'] == 'SUCCEEDED':
      send_slack(message)
    else :
      send_slack(message)

    return message
