#!/bin/bash

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

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

echo -n "Configuring and installing the $COMPONENT repo"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> $LOGFILE
yum install nodejs -y  &>> $LOGFILE
stat $?

id $APPUSER $LOGFILE
if [ $? -ne 0 ] ; then

    echo -n "Creating the service account"
    useradd $APPUSER &>> $LOGFILE
    stat $?

fi

echo -n "downloading $COMPONENT"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "copying the $COMPONENT to $APPUSER home directory"
cd /home/$APPUSER
unzip -o /tmp/catalogue.zip $LOGFILE
stat $?

echo -n "modifying the owbership"
mv $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?



