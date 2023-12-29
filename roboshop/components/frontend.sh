#!/bin/bash

COMPONENT=frontend

source components/common.sh

echo -n "Installing Nginx"
yum install nginx -y &>> $LOGFILE

stat $?

echo -n "Downloading $COMPONENT component"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

stat $?

echo -n "Performing cleanup"
cd /usr/share/nginx/html
rm -rf * &>> $LOGFILE

stat $?

echo -n "extracting $COMPONENT conponent"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "updating backend component"
for component in catalogue ; do
 sed -i -e "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
stat $?

echo -n "starting $COMPONENT conponent"
systemctl deamon-reload &>> $LOGFILE
systemctl enable nginx &>> $LOGFILE
systemctl restart nginx &>> $LOGFILE
stat $?


