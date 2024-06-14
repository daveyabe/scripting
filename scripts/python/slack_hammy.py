import requests
import os
import json

def send_slack_message(message):
    slack_token = os.environ['SLACK_TOKEN']
    channel_id = 'C06FG7VBWPQ'

    url = 'https://slack.com/api/chat.postMessage'
    headers = {'Authorization': f'Bearer {slack_token}'}
    payload = {
        'channel': channel_id,
        'text': message
    }

    response = requests.post(url, headers=headers, json=payload)

    if response.status_code == 200:
        print("Message sent successfully!")
    else:
        print("Failed to send message.")

def lambda_handler(event, context):
    
    bar_code = event['barcode']
    message = f"Hallelujah, yeah, alright!!! We got us a <https://limbo.project.com/plates/{bar_code}/contents|TXTL> transfer!"
    send_slack_message(message)
