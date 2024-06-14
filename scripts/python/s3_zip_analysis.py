import requests
import os
import json
import zipfile
import urllib.parse
from io import BytesIO
from mimetypes import guess_type
import boto3


s3 = boto3.client('s3')

def send_slack_message(message):
    slack_token = os.environ['SLACK_TOKEN']
    channel_id = 'C06GAPVACQ3'

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
    bucket = event['Records'][0]['s3']['bucket']['name']
    zip_key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])
    justfilename = zip_key.split("/")[-1]
    
    try:
        # Slack zip data arrival
        message = f"Heads up soldiers, we've got new LAMBDA RAPIDFIRE data arriving!     Zip and extracted data at the following S3 bucket: {bucket}/{zip_key}"
        send_slack_message(message)
        # Get the zipfile from S3
        obj = s3.get_object(Bucket=bucket, Key=zip_key)
        z = zipfile.ZipFile(BytesIO(obj['Body'].read()))
        
        # extract and upload each file in the zipfile
        for filename in z.namelist():
            content_type = guess_type(filename, strict=False)[0]
            s3.upload_fileobj(
                Fileobj=z.open(filename),
                Bucket=bucket,
                #Key=zip_key+'/'+filename,
                Key='data/unzipped/'+justfilename+'/'+filename,                
                ExtraArgs={'ContentType': content_type}
            )
            
    except Exception as e:
        print('Error getting object {zip_key} from bucket {bucket}.')
        raise e
