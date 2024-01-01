#!/bin/bash

COMPONENT=mysql

source components/common.sh

echo -n "configuring and installing the $COMPONENT"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE    
yum install mysql-community-server -y  &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl enable mysqld &>> $LOGFILE
systemctl start mysqld  &>> $LOGFILE
stat $?

echo -n "changing default password"
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}')
stat $?

echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "Performing root password reset"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED by 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PASSWORD} &>> $LOGFILE
    stat $?
fi

echo "show pulgins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>> $LOGFILE
if [ $? -eq 0 ] ; then
    echo -n "uninstalling password plugin validation"
    echo "UNINSTALL PLUGIN validate_password;" | mysql -uroot -pRoboShop@1 |  &>> $LOGFILE  
    stat $?
fi

echo -n "downloading in $COMPONENT schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "Extracting the $COMPONENT schema"
cd /tmp
unzip -o $COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "injecting the $COMPONENT schema"
cd $COMPONENT-main
mysql -u root -pRoboShop@1 <shipping.sql  &>> $LOGFILE
stat $?




