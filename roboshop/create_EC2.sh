#!/bin/bash

COMPONENT="$1"
ENV=$2
HOSTED_ZONE=Z04725971RVPYECKIUM2P

if [ -z "$1" ] || [ -z "$2" ]; then
   echo -e "\e[31m Component name is needed  and env name is needed \e[0m"
   exit 1
fi

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=B54-allow-all" |jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')

echo -e "AMI is  \e[32m $AMI_ID \e[0m"
echo -e "security group ID is \e[32m $SG_ID \e[0m"

create_EC2(){

   echo -n "launching the $COMPONENT-$ENV server"
   IPADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT-$ENV}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
   echo -e "private IP Address \e[32m $IPADDRESS \e[0m"

   echo -n "creating DNS record for $COMPONENT"
   sed -e "s/Component/$COMPONENT-$ENV/" -e "s/IPAddress/$IPADDRESS/" route53.json > /tmp/record.json
   aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE --change-batch file:///tmp/record.json

}

if [ $1 == all ] ; then

   for component in frontend redis catalogue mysql payment rabbitmq user cart shipping  mongodb ; do
      COMPONENT=$component
      create_EC2
   done
else
    create_EC2
fi
