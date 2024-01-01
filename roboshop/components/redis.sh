#!/bin/bash

COMPONENT=redis

source components/common.sh

echo -n "Configuring $COMPONENT :"
curl -s -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing $COMPONENT :"
yum install redis-6.2.13 -y &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl enable $COMPONENT &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
stat $?

echo -n "updating $COMPONENT config"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf
stat $?

echo -n "starting $COMPONENT conponent"
systemctl daemon-reload $COMPONENT &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $?









