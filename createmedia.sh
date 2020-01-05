#!/bin/bash
echo "Linux installation media script. Please see below the detected devices and addintify the name of your USB device."
lsblk
echo "Enter the full name for the device, E.G. \"sdx\". Replacing X with the correct character."
read devname
echo "Enter the full path to your ISO installation file. E.G. /home/user/Downloads/linux.iso"
read -e filedir
echo "Device /dev/$devname will be wiped and $filedir will be copied."
read -p "Do you wish to proceed? y/n: " -n 1 -r
echo \n
if [[ $REPLY =~ ^[Yy]$ ]]
then
    dd if=/dev/zero of=/dev/$devname bs=1M status=progress
    echo "Wipe complete, coping new data"
    dd if=$filedir of=/dev/$devname status=progress
    echo "Operation complete"
fi
sync