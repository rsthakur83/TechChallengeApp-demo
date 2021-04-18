#!/bin/bash

aws ecs describe-services  --services appecsservice

if [ $? -eq 0 ];then
    
else
     echo "Deploying Infra"
     ../terraform init
     ../terraform plan
     ../terraform apply --auto-approve
fi

