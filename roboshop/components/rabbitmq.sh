#!/bin/bash

COMPONENT=rabbitmq

source components/common.sh

echo -n "configuring in $COMPONENT"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash 
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
stat $?

echo -n "installing $COMPONENT"
yum install rabbitmq-server -y &>> $LOGFILE
stat $?


echo -n "starting $COMPONENT"
systemctl enable rabbitmq-server  &>> $LOGFILE
systemctl start rabbitmq-server &>> $LOGFILE
stat $?

echo -n "creating the $COMPONENT $APPUSER"
rabbitmqctl add_user roboshop roboshop123   
stat $?

echo -n "configuring the $COMPONENT $APPUSER privilege"
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
stat $?


