#!/bin/bash


role=`aws iam get-role --role-name ecsTaskExecutionRole --query 'Role.RoleName' --output text`

if [ "$role" = "ecsTaskExecutionRole" ];then
	echo "Role Exist"	
else
	echo "Role Doest Not Exist Creating!!!!!"
	sed -i  "s|aws-region|$aws_region|g"     ecs_task_execution_role.tf
	../terraform init
	../terraform plan
	../terraform apply --auto-approve
fi	
