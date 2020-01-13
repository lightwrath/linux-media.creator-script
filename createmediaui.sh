#!/bin/bash
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
confirm=1
while [ $confirm -eq 1 ]; do
    exec 3>&1
    devName=$(dialog \
    --backtitle "Linux installation media creator" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please identify your USB device below" 0 0 4 \
    $(lsblk -o NAME,SIZE | grep ^sd[a-z]) \
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

    exec 3>&1
    isoName=$(dialog \
    --backtitle "Linux installation media creator" \
    --title "Select ISO file" \
    --clear \
    --cancel-label "Exit" \
    --fselect "/home/" 0 0 4 \
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

    dialog --yesno "All data will be removed from /dev/$devName and $isoName will be copied. Ok to proceed?" 0 0
    confirm=$?
done
clear
dd if=/dev/zero of=/dev/$devName bs=1M status=progress
echo "Wipe complete, coping new data"
dd if=$isoName of=/dev/$devName status=progress
sync
echo "Operation complete"