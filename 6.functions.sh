#!/bin/bash

sample(){

    echo " I am a sample function"
    echo " I can run any no of times"
    echo "calling status function"
    status
}

sample

status(){

TODAYS_DATE=$(date +%F)
NO_OF_SESSION=$(who | wc -l)
echo -e "Todays date is \e[34m  $TODAYS_DATE \e[0m"

echo -e "No of session open \e[34m $NO_OF_SESSION \e[0m" 
}