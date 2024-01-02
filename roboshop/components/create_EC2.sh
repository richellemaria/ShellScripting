#!/bin/bash

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')

echo -n "AMI is  \e[32m $AMI_ID \e[0m"

echo -n "launching the server"
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro