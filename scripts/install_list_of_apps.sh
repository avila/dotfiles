#!/bin/bash

## declare an array variable
declare -a lisf_of_apps=("R" "rstudio")

for app in "${lisf_of_apps[@]}"
do
	echo "Do you wish to install $app ?"
	select yn in "Yes" "No" "QUIT"; 
	do
    	case $yn in
   	    	Yes ) apt install $app; break;; # maybe needs sudo apt, or run 
	        No ) break;;                    # script as sudo
    	        QUIT ) exit;;
    	esac
	done
done

#adapted from: https://stackoverflow.com/questions/226703/
#and https://stackoverflow.com/questions/8880603
