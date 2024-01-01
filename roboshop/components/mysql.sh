#!/bin/bash

COMPONENT=mysql

source components/common.sh

echo -n "configuring and installing the $COMPONENT "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo $>> $LOGFILE    
yum install mysql-community-server -y  $>> $LOGFILE  
stat $?

echo -n "starting $COMPONENT"
systemctl enable mysqld $>> $LOGFILE 
systemctl start mysqld $>> $LOGFILE 


