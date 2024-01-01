#!/bin/bash

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

CREATE_USER(){

    id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ] ; then

        echo -n "Creating the service account"
        useradd $APPUSER &>> $LOGFILE
        stat $?

    fi
}

DOWNLOAD_EXTRACT(){
    echo -n "downloading $COMPONENT"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "copying the $COMPONENT to $APPUSER home directory"
    cd /home/$APPUSER/
    rm -rf $COMPONENT &>> $LOGFILE
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
    stat $?

    echo -n "modifying the ownership"
    mv $COMPONENT-main/ $COMPONENT
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT/
    stat $?

}
NPM_INSTALL(){

    echo -n "Generating npm $COMPONENT artifacts"
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOGFILE
    stat $?
    
}

CONFIG_SERVICE(){

    echo -n "updating $COMPONENT systemfile"
    sed -i  -e 's/USERHOST/user.roboshop.internal/'  -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "starting $COMPONENT service"
    systemctl daemon-reload &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?

}

NODEJS(){

    echo -n "Configuring and installing the $COMPONENT repo"
    yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> $LOGFILE
    yum install nodejs -y  &>> $LOGFILE
    stat $?
 
    CREATE_USER

    DOWNLOAD_EXTRACT

    NPM_INSTALL

    CONFIG_SERVICE

}

MVN_PACKAGE(){

    echo -n "preparing  $COMPONENT artifact"
    cd /home/$APPUSER/$COMPONENT
    mvn clean package &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?

}

JAVA(){

    echo -n "installing Maven"
    yum install maven -y &>> $LOGFILE
    stat $?

    CREATE_USER

    DOWNLOAD_EXTRACT
  
    MVN_PACKAGE

    CONFIG_SERVICE

}

PYTHON(){


   echo -n "installing python"
   yum install python36 gcc python3-devel -y  &>> $LOGFILE
   stat $?

   CREATE_USER 

   DOWNLOAD_EXTRACT

   echo -n "installing $COMPONENT"
   cd /home/$APPUSER/$COMPONENT 
   pip3 install -r requirements.txt &>> $LOGFILE
   stat $?


   USERID=$(id -u roboshop)
   GROUPID=$(id -g roboshop)

   echo -n "updating useradd and groupadd in $COMPONENT.ini file"
   sed -i -e '/^uid/ c uid=$USERID/' -e '/^gid/ c uid=$GROUPID/' /home/$APPUSER/$COMPONENT/$COMPONENT.ini
   CONFIG_SERVICE

}