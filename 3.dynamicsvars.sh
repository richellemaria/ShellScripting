#!/bin/bash

TODAYS_DATE=$(date +%F)
NO_Of_SESSION=$(who wc -l)
echo -e "Todays date is \e[34m  $TODAYS_DATE \e[0m"

echo -e "No of session open \e[34m $NO_OF_SESSION \e[0m"