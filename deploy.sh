#!/bin/bash
environment="$1"
region1="$2"
region2="$3"
if [[ -z "$environment" ]] || [[ -z "$region1" ]] || [[ -z "$region2" ]]; then
  echo "Usage: $0 <environment> <aws-region1> <aws-region2>"
  exit 1
fi

echo -e "\n+++++ Starting deployment +++++\n"

rm -rf ./bin
mkdir ./bin
mkdir ./bin/s3update

echo "+++++ build go packages +++++"

cd golang/s3update
go get
env GOOS=linux GOARCH=amd64 go build -o ../../bin/s3update/s3update
if [ $? -ne 0 ]
then
    echo "build s3update packages failed"
    exit 1
fi

echo "+++++ apply terraform +++++"
cd ../../terraform
terraform init
if [ $? -ne 0 ]
then
    echo "terraform init failed"
    exit 1
fi

terraform workspace new $environment
terraform workspace select $environment

terraform apply --var "aws_region1=$region1" --var "aws_region2=$region2" --auto-approve

echo -e "\n+++++ Deployment done +++++\n"