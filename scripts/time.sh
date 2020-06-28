#!/bin/sh

function pause() {
    read -p "$*"
}

function ntp(){
    NTPSTATUS=$(timedatectl status | grep NTP | awk '{print $3}')

    dialog --stdout --yesno "Enable network sync?\nntp status: ${NTPSTATUS}" 6 25
    NTPN=$?
    ((NTPN ^= 1))
    
    NTPB=0
    [ "$NTPSTATUS" == "active" ] && NTPB=1
    
    if [ $NTPN -ne $NTPB ] 
    then
        clear
        timedatectl set-ntp $NTPN ||
            pause "Press [Enter] to continue"
    fi
}

ntp

while true
do
    HR=$(date +%H)
    MIN=$(date +%M)
    SEC=$(date +%S)
    DAY=$(date +%d)
    MOUNTH=$(date +%m)
    YEAR=$(date +%Y)

    menu=$(dialog --stdout --menu "time manager" 0 0 0 q "exit" t "set time" d "set date" s "network sync")
    case $menu in
        "s")
            ntp
            ;;
        "t")
            NEWTIME=$(dialog --stdout --timebox "enter time" 0 0 $HR $MIN $SEC)
            clear
            timedatectl set-time $NEWTIME ||
                pause "Press [Enter] to continue" 
            ;;
        "d")
            NEWDATE=$(dialog --stdout --calendar "choose date" 0 0 $DAY $MOUNTH $YEAR)
            NYEAR=$(echo $NEWDATE | cut -d'/' -f3)
            NMOUN=$(echo $NEWDATE | cut -d'/' -f2)
            NDAY=$(echo $NEWDATE | cut -d'/' -f1)
            clear
            timedatectl set-time "${NYEAR}-${NMOUN}-${NDAY} ${HR}:${MIN}:${SEC}" ||
                pause "Press [Enter] to continue"
            ;;
        "q")
            break;
            ;;
    esac
done

ntp
clear
