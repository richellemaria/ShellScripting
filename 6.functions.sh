#!/bin/bash

sample(){

    echo " I am a sample function"
    echo " I can run any no of times"
    echo "calling status function"
    status
}

sample

status(){


echo -e "Todays date is \e[34m  $(date +%F) \e[0m"

echo -e "No of session open \e[34m $(who | wc -l) \e[0m" 
}