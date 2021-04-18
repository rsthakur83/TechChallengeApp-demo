#!/bin/bash

ECS_CLUSTER=`grep -A 1 "ECS cluster name" ../variable.tf |grep default|cut -d'"' -f 2`
SERVICE_NAME=`grep -A 1 "ECS App Service Name" ../variable.tf |grep default|cut -d'"' -f 2`
appsvc=`aws ecs describe-services --cluster $ECS_CLUSTER --service $SERVICE_NAME  --query 'services[*].[serviceName]' --output text`
git clone app-repo

if [ "$appsvc" = "$SERVICE_NAME" ];then
	repo="ecr-repo"
	AWS_REGION="aws-region"
	ECS_CLUSTER=`grep -A 1 "ECS cluster name" ../variable.tf |grep default|cut -d'"' -f 2`
	SERVICE_NAME=`grep -A 1 "ECS App Service Name" ../variable.tf |grep default|cut -d'"' -f 2`
	TASK_FAMILY=`grep -A 1 "ECS Task Family" ../variable.tf |grep default|cut -d'"' -f 2`

	export RELEASE_NUMBER="$(cat TechChallengeApp/cmd/root.go |grep Version|awk '{print $2}'|cut -d '"' -f2)"
	export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
	TASK_DEFINITION=`aws ecs describe-task-definition --task-definition $TASK_FAMILY --region $AWS_REGION`
	NEW_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$repo:$RELEASE_NUMBER"
	NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "$NEW_IMAGE" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
	NEW_TASK_INFO=$(aws ecs register-task-definition --region "$AWS_REGION" --cli-input-json "$NEW_TASK_DEFINTIION")
	NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
	OLD_TASK_ID=`aws ecs list-tasks --cluster $ECS_CLUSTER --desired-status RUNNING --family $TASK_FAMILY | egrep "task/" | sed -E "s/.*task\/(.*)\"/\1/"`
	echo $NEW_REVISION
	TASK_REVISION=`aws ecs describe-task-definition --task-definition $TASK_FAMILY | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
	CURRENT_REVISION_NUMBER=`echo $TASK_REVISION| cut -d ',' -f 1`
	FINAL_REVISION=$(($CURRENT_REVISION_NUMBER - 1))
	for old_task in $OLD_TASK_ID;do aws ecs --region $AWS_REGION  stop-task --cluster $ECS_CLUSTER --task $old_task;done
	aws ecs update-service --cluster ${ECS_CLUSTER} \
                       --service ${SERVICE_NAME} \
                       --task-definition ${TASK_FAMILY}:${NEW_REVISION} --desired-count 2 --force-new-deployment
	sleep 300
else
	cd ..;terraform init;terraform plan ;terraform apply --auto-approve;sleep 300
fi
