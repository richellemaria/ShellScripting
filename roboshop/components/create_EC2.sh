#!/bin/bash

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=B54-allow-all" |jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

echo -e "AMI is  \e[32m $AMI_ID \e[0m"
echo -e "security group ID is \e[32m $SG_ID \e[0m"

echo -n "launching the server"
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro  --tag-specifications 'ResourceType=instance,Tags=[{Key=name,Value=payment}]' | jq .

