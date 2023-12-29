#!/bin/bash

COMPONENT=user

source components/common.sh

echo -n "Configuring and installing the $COMPONENT repo"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> $LOGFILE
yum install nodejs -y  &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then

    echo -n "Creating the service account"
    useradd $APPUSER &>> $LOGFILE
    stat $?

fi

echo -n "downloading $COMPONENT"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "copying the $COMPONENT to $APPUSER home directory"
cd /home/$APPUSER
rm -rf $COMPONENT &>> $LOGFILE
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "modifying the owbership"
mv $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

echo -n "Generating npm $COMPONENT artifacts"
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?

echo -n "updating $COMPONENT systemfile"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
sed -i -e 's/REDIS_DNSNAME/redis.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting $COMPONENT service"
systemctl daemon-reload &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $?








