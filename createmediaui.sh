#!/bin/bash
DIALOG_CANCEL=1
DIALOG_ESC=255

devList=`lsblk -o NAME,SIZE | grep ^sd[a-z]`
exec 3>&1
devName=$(dialog \
--backtitle "Linux installation media creator" \
--title "Menu" \
--clear \
--cancel-label "Exit" \
--menu "Please identify your USB device below" 0 0 4 \
$devList
2>&1 1>&3)

exit_status=$?
exec 3>&-
case $exit_status in
$DIALOG_CANCEL)
    clear
    echo "Program terminated."
    exit
    ;;
$DIALOG_ESC)
    clear
    echo "Program aborted." >&2
    exit 1
    ;;
esac
echo $devName
#devname=$(dialog --menu "Linux installation media script. Please see below the detected devices and identify the name of your USB device." 20 50 15 $(lsblk -o NAME,SIZE | grep ^sd[a-z]))

