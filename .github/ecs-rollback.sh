
aws ecr batch-delete-image --repository-name $environment --image-ids imageTag=$tag
MY_MANIFEST=$(aws ecr batch-get-image --repository-name $environment --image-ids imageTag=$hash --region us-east-1 --query images[].imageManifest --output text)
aws ecr put-image --repository-name $environment --image-tag $tag --image-manifest "$MY_MANIFEST" --region us-east-1
