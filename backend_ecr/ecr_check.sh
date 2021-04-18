#!/bin/bash

ecr_name="ecr-repo"
repoout=`aws ecr describe-repositories --repository-names ecr-repo --query 'repositories[*].[repositoryName]' --output text --region aws-region`
echo $repoout
echo $ecr_name
echo `pwd`
env
echo "aws ecr describe-repositories --repository-names ecr-repo --query 'repositories[*].[repositoryName]' --output text"
if [ "$repoout" = $ecr_name ]
then
     echo "Repo already exist"
else
     echo "Repo does not exist, Creating it"
     ../terraform init
     ../terraform plan
     ../terraform apply --auto-approve
fi
