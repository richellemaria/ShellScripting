#!/bin/bash

COMPONENT=rabbitmq

source components/common.sh

echo -n "configuring in $COMPONENT"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "installing $COMPONENT"
yum install rabbitmq-server -y &>> $LOGFILE
stat $?


echo -n "starting $COMPONENT"
systemctl enable rabbitmq-server  &>> $LOGFILE
systemctl start rabbitmq-server &>> $LOGFILE
stat $?

rabbitmqctl list_users | grep roboshop &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "creating the $COMPONENT $APPUSER"
    rabbitmqctl add_user roboshop roboshop123   
    stat $?
fi

echo -n "configuring the $COMPONENT $APPUSER privilege"
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
stat $?


