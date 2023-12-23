#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ] ; then
  echo -e "\e[32m The script is excepted to  be run as sudo user \e[0m"

fi

echo "Installing Nginx"
yum install nginx -y &>> "/tmp/""

