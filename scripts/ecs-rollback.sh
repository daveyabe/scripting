#!/bin/sh
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws ecr batch-delete-image --repository-name graphql/$environment --image-ids imageTag=$tag
MY_MANIFEST=$(aws ecr batch-get-image --repository-name graphql/$environment --image-ids imageTag=$hash --region us-east-1 --query images[].imageManifest --output text)
aws ecr put-image --repository-name graphql/$environment --image-tag $tag --image-manifest "$MY_MANIFEST" --region us-east-1
