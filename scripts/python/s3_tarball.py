import boto3
import botocore
import tarfile
import requests,json
from requests.structures import CaseInsensitiveDict

from io import BytesIO
s3_client = boto3.client('s3')

def lambda_handler(event, context):

    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    

    url = "https://api.bitbucket.org/2.0/repositories/organization/illumina_sequencing/pipelines/"
    headers = CaseInsensitiveDict()
    headers["Content-Type"] = "application/json"
    headers["Authorization"] = "Basic 123456"

    input_tar_file = s3_client.get_object(Bucket = bucket, Key = key)
    input_tar_content = input_tar_file['Body'].read()

    print(bucket)
    print(key)

    with tarfile.open(fileobj = BytesIO(input_tar_content)) as tar:
        for tar_resource in tar:
            if (tar_resource.isfile()):
                inner_file_bytes = tar.extractfile(tar_resource).read()
                s3_client.upload_fileobj(BytesIO(inner_file_bytes), Bucket = bucket, Key = "loopg/" + tar_resource.name)

    key2=key.replace("loopg/","")
    print(key2)
    payload = {
        "target": {
          "ref_type": "branch",
          "type": "pipeline_ref_target",
          "ref_name": "master",
          "selector": {
            "type": "custom",
            "pattern": "RunAppPy"
          }
        },
        "variables": [
          {
            "key": "TARBALL",
            "value": key2
          }
        ]
    }    
    payload_json = json.dumps(payload)

    resp = requests.post(url, headers=headers, data=payload_json)
    print(resp.text)
