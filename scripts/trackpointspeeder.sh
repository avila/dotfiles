#!/bin/bash
#
# This script gives access to ThinkPad TrackPoint's speed and sensitivity
# settings, allows setting, saving, loading them and also can install itself
# into /usr/bin and create a desktop antry for autostart at login.
#
# It basically does something like this:
# #echo 150 > /sys/devices/platform/i8042/serio1/serio2/speed
# #echo 240 > /sys/devices/platform/i8042/serio1/serio2/sensitivity
#
# Author:   docphees
# Version:  0.7.0
# License:  GPL
# Year:     2016
#
#TODO:
#
# MORE INFORMATION ON THE TRACKPOINT HERE:
# https://wiki.archlinux.org/index.php/TrackPoint
#
#VERSION
selfname="TrackPointSpeeder"
selfcall="trackpointspeeder"
selfversion=0
selfsubversion=7
selfsubsubversion=0
selfyear=2016
selflicense="GPL"
#
#VERSION HISTORY
#
#v0.7
# Autorestore now uses the /etc/xdg/autostart and should work with most
# desktop environments.
# A new daemon mode is being evaluated but still too buggy.
#v0.5
# bughunt
#v0.4
# Added a delayed second call to the automatic restore to make sure
# trackpoint settings are not overwritten by default values.
# Code cleanup
#v0.3
# Added activation and deactivation
#v0.2
# Added save and restore functionality and a very basic
# fire once activation, which is really not production ready.
#v0.1
# Added basic application framework and functionality.


#####################################################
###### FUNCTIONS
function find_trackpoint {
	debugmsg "Function find_trackpoint"
	TPPATH=`find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'`
}
function get_settings {
    debugmsg "Function get_settings"

	echo "TrackPoint device found at"
    echo "    "$TPPATH
    echo ""

	tpspeed=`cat $TPPATH"/speed"`
	tpsensitivity=`cat $TPPATH"/sensitivity"`
    echo "Current TrackPoint settins are:"
    echo "Speed:       "$tpspeed
    echo "Sensitivity: "$tpsensitivity
}
########
function set_settings {
	debugmsg "Function set_settings, parameter: $1"

	echo "TrackPoint device found at"
    echo "    "$TPPATH
    echo ""

	#split the argument in two values
	IFS=","	read -r speed sensitivity <<< $1
	#exit if argument does not contain two values
	if [ -z "$speed" -o -z "$sensitivity" ];then
	    usage "The set command requires two comma seperated values!\nThe provided argument was: $1"
	    exit
	fi
	#exit if arguments out of bounds
	if [ $speed -gt 255 -o $speed -lt 1 ];then
	  usage "Speed must be set to a value from 1 to 255."
	  exit
	fi
	if [ $sensitivity -gt 255 -o $sensitivity -lt 1 ]; then
	  usage "Sensitivity must be set to a value from 1 to 255."
	  exit
	fi
	debugmsg "speed: $speed\nsensitivity: $sensitivity"
	echo "Setting speed to $speed and sensitivity to $sensitivity."
	echo $speed>$TPPATH"/speed"
	echo $sensitivity>$TPPATH"/sensitivity"
	}
########
function save_settings {
	debugmsg "Function save_settings"
	#usage "Saving not yet available!"
	#place to save: /var/lib/appname
	if [ ! -d /var/lib/$selfcall/ ]; then
        mkdir -p "$savepath"
    fi
    get_settings
    echo "$tpspeed,$tpsensitivity">$savepath/$savefile
    echo "Settings saved."
	exit
}
########
function restore_settings {
	debugmsg "Function restore_settings"
	if [ -f $savepath/$savefile ]; then
	    set_settings `cat $savepath/$savefile`
	    echo "Settings restored."
	    restore_time=`stat -c %Y $TPPATH/speed`

	    #Restoring twice if "ensure" parameter has been given
	    #This is still buggy! (TODO)
	    debugmsg "ENSURE: $opt_restore_sensure"
	    if [ "$opt_restore_ensure" = "1" ]; then
	        n=0
	        while [ $n -lt 40 ];do
	        debugmsg "ENSURE: Round $n of 40."
				sleep 5
				debugmsg `stat -c %Y $TPPATH/speed`
				if [ ! $restore_time = `stat -c %Y $TPPATH/speed` ]; then
					set_settings `cat $savepath/$savefile`
					restore_time=`stat -c %Y $TPPATH/speed`
				fi
				n=$[$n+1]
			done
		fi
		
	else
		echo "No saved settings found."
	fi
	exit
}
########
function activate {
	#AKA install
	debugmsg "Function activate"
	
	#First deactivate an allready installed trackpointspeeder script.
	deactivate
		
	#Now install the script correctly:
	#1. add a .desktop file to /etc/xdg/autostart/
	echo "Creating autostart file."
	echo "[Desktop Entry]
Version=1.0
Type=Application
Name=trackpointspeeder
Comment=
Exec=sudo trackpointspeeder -E
Icon=
Path=
Terminal=false
StartupNotify=false
">/etc/xdg/autostart/trackpointspeeder.desktop
	chown root /etc/xdg/autostart/trackpointspeeder.desktop
	chgrp root /etc/xdg/autostart/trackpointspeeder.desktop
	#2. add trackpointspeeder to /etc/sudoers file
	echo "Setting rights for script."
	echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/trackpointspeeder">>/etc/sudoers
}
########
function deactivate {
	#AKA uninstall
	debugmsg "Function deactivate"
	#1. remove .desktop file from /etc/xdg/autostart/
	if [ -f /etc/xdg/autostart/trackpointspeeder.desktop ]; then
		sudo rm /etc/xdg/autostart/trackpointspeeder.desktop
	fi
	#2. remove script excemption from /etc/sudoers
	sudo sed -i "/trackpointspeeder/d" /etc/sudoers
}
########
function interactive {
	debugmsg "Function interactive"
	usage "Interactive mode not yet available!"
	#interactive mode is the fallback if other options have not been chosen.
	#TODO run a simple menu in a loop to change the values until quit or
	#     restore or main menu
	exit
}
########
function update {
	### trackpointspeeder -U yes updates the /usr/bin from ./
	debugmsg "Function update"
	echo "Trying to update $selfcall..."
	if [ -f ./$selfcall ]; then
		cp $selfcall /usr/bin/
		if [ -f /usr/bin/$selfcall ]; then
			echo "... successfully updated!"
		else
			echo "... unsuccessfully. Sorry."
		fi
	else
		echo "No file ./$selfcall found"
	fi
	exit
}
########
function usage {
debugmsg "Function usage"
echo "$selfname v$selfversion.$selfsubversion.$selfsubsubversion (@$selfyear), $selflicense"
echo ""
echo "This sript allows to read and change the speed and sensitivity
settings of ThinkPad TrackPoint devices.
The script requires write access to the device and must be run
with root privileges.

usage: $selfcall [OPTION]
Selecting an option is mandatory! Options are:
-g        Prints out the current speed settings
-s        Sets both speed and sensitivity values.
          Requires two space/comma seperated integer
          arguments from 1 to 255.
          -s SPEED,SENSITIVITY
          Example: -s 100,200
-S        Saves the current speed and sensitivity
          values.
-R        Restores a previously saved speed and
          sensitivity values.
-E        Restores a previously saved speed like -R
          and tries to ensure it stays set.
-i        Install trackpointspeeder daemon on boot.
-u        Uninstall trackpointspeeder daemon on boot.
-h        Print this help text."
if [ ! -z "$1" ]; then
  echo ""
  echo -e $1
fi
}
function debugmsg {
	#Prints the argument as message only when debug = 1 (debug flag set)
	#Allows for multiline messages (use "\n").
	if [ $debug = 1 ]; then
		if [ ! -z "$1" ]; then
			echo -e "[DEBUG: $1 ]"
		fi
	fi
}

function daemon {
	# VERY UNCOMPLETE!!!
	#Daemon mode. (restore without the need to having found a trackpoint
	#immediately.
    while [ ! -f $TPPATH"/speeds" ]; do
		find_trackpoint
        debugmsg "No valid Trackpoint device has been found (yet)!"
        sleep 10
    done
    
	#Restoring twice if "ensure" parameter has been given
	#This is still buggy! (TODO)
	debugmsg "ENSURE: $opt_restore_sensure"
	n=0
	while [ $n -lt 60 ];do
	debugmsg "ENSURE: Round $n of 60."
		sleep 5
		debugmsg `stat -c %Y $TPPATH/speed`
		if [ ! $restore_time = `stat -c %Y $TPPATH/speed` ]; then
			set_settings `cat $savepath/$savefile`
			restore_time=`stat -c %Y $TPPATH/speed`
		fi
		n=$[$n+1]
	done
}

#FUCTIONS /
######################################################

#### path/filename for saving/restoring
savepath="/var/lib/$selfcall"
savefile="restorevalue"
#### initialisation
opt_interactive=0
opt_get=0
opt_set=0
opt_save=0
opt_restore=0
opt_restore_ensure=0
opt_activate=0
opt_deactivate=0
opt_daemon=0
tpspeed=""
tpsensitivity=""
setspeed=""
setsensitivity=""
restore_time=0
#DEBUGGING FLAG
debug=0


#find TrackPoint device path and make sure a TrackPoint device exists.
#TPPATH=`find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'`

find_trackpoint
if [ ! -f $TPPATH"/speed" ]; then
  usage "No valid Trackpoint device has been found!"
  exit
fi

while getopts :gs:SREiuhU: opt; do
	debugmsg "Reading parameters"
	case $opt in
		g)	opt_get=1
			;;
		s)	opt_set=1
			set_values=$OPTARG
			;;
		S)	opt_save=1
			;;
		R)	opt_restore=1
		    ;;
		E)  opt_restore=1
			opt_restore_ensure=1
			;;
		i)	opt_activate=1
			;;
		u)	opt_deactivate=1
			;;
		d)  opt_daemon=1
			;;
		U)	#the hidden update function
			if [ "$OPTARG" = "yes" ]; then
				update
			else
				usage
			fi
			exit
			;;
		h)	usage
			exit
			;;
		\?)	usage "Invalid option: -$OPTARG"
			exit
			;;
	esac
	#echo "SUM: "$(($opt_interactive + $opt_get+$opt_set+$opt_save+$opt_restore))
done

######EXIT condidtions
#exit if none option has been chosen
if [ -z "$1" ]; then
  usage
  exit
fi
#exit if more than one option has been chosen
if [ $[$opt_interactive + $opt_get + $opt_set + $opt_save + $opt_restore + $opt_activate + $opt_deactivate] -gt 1 ]; then
	echo "Multiple options where chosen. Reduce choice to one option!"
	echo ""
	usage
	exit
fi
debugmsg "$opt_interactive, $opt_get, $opt_set, $opt_save, $opt_restore, $opt_activate, $opt_deactivate"

################### MAIN

if [ $opt_get = 1 ]; then
	get_settings
elif [ $opt_daemon = 1 ]; then
	daemon
elif [ $opt_set = 1 ]; then
	set_settings $set_values
elif [ $opt_save = 1 ]; then
	save_settings
elif [ $opt_restore = 1 ]; then
	restore_settings
elif [ $opt_activate = 1 ]; then
	activate
	exit
elif [ $opt_deactivate = 1 ]; then
	deactivate
	exit
else
	interactive
fi

