branch, owner, repo, workflow_name, ghp_token="master", "organization", "levi", "build-and-run.yml", "github_pat_12345"

import boto3
import botocore
import requests

def lambda_handler(branch, owner, repo, workflow_name,ghp_token):
    url = f"https://api.github.com/repos/{owner}/{repo}/actions/workflows/{workflow_name}/dispatches"
    
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {ghp_token}",
        "Content-Type": "application/json"
    }

    data = '{"ref":"master","inputs":{"ENVIRONMENT":"PRODUCTION"}}'
    
    resp = requests.post(url, headers=headers, data=data)
    return resp
    
response=lambda_handler(branch, owner, repo, workflow_name, ghp_token)

if response.status_code==204:
    print("Workflow Triggered!")
else:
    print("Something went wrong.")
