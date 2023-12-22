#!/bin/bash

echo -e "\e[34m this is foreground colour \e[0m"
echo -e "\e[43;32m this background with foreground colour \e[0m"

a=10
b=15

echo "the value of a is $a"
echo "the value of d is $d"

todays_date=$(date +%D)
echo -e "todays date is \e[34m $todays_date \e[0m"

echo "the name of the script is $0"
echo "my name is $1"
echo "I am learning $2"
echo $*
echo $@
echo $$
echo $#  
echo $?
