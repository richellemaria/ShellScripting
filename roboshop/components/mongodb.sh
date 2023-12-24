#!/bin/bash

COMPONENT=mongodb
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

echo -n "Configuring $COMPONENT :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT :"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "updating mongod config"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
stat $?

echo -n "starting $COMPONENT conponent"
systemctl deamon-reload mongod &>> $LOGFILE
systemctl enable mongod &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "downloading the $COMPONENT Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting in $COMPONENT conponent"
cd /tmp
unzip mongodb.zip &>> $LOGFILE
stat $?

echo -n "Injecting the schema"
cd $COMPONENT-main
mongo < catalogue.js
mongo < users.js
stat $?








