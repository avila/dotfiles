#!/bin/sh
exitcode=1 
# define variables
pathUSB="/run/media/avila/usbData/elementary@x200s/Documents/"
syncFolder="/home/avila/Documents/"
#do check if usb flash is mounted
if test -e $pathUSB ; then 
  exitcode=0
  #from folder to usb if the files are newers
  rsync -avu --inplace  $syncFolder $pathUSB --delete ;
  #from usb to folder if the files are newers
  rsync -avu --inplace $pathUSB $syncFolder ;
fi 
#if the flash is not mounted exit with exitcode=1 
exit $exitcode
