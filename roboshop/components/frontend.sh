#!/bin/bash

COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"
ID=$(id -u)
if [ $ID -ne 0 ] ; then
  echo -e "\e[31m The script is excepted to  be run as sudo user \e[0m"
  exit 1
fi

stat(){
    if [ $1 -eq 0 ] ; then
      echo -e "\e[32m success \e[0m"
    else 
      echo -e "\e[32m failure \e[0m" 
      exit 2
    fi    
}

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
for component in catalogue ; downloading
 sed -i -e "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
stat $?

echo -n "starting $COMPONENT conponent"
systemctl deamon-reload &>> $LOGFILE
systemctl enable nginx &>> $LOGFILE
systemctl start nginx &>> $LOGFILE
stat $?


