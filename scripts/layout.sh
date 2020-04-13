#!/bin/sh

MODE="--mode 1920x1080"
EDP1="--output eDP-1 --primary" # main laptop screen
HDMI="--output HDMI-1" # hdmi

MENU="laptop:on \nhdmi:off \nhdmi:up \nhdmi:left \nhdmi:right \nhdmi:down \nlaptop:off"

[ -z $1 ] && exit 0

[ $1 = "menu" ] && 
    $0 $(echo -e $MENU | rofi -dmenu -config ~/.config/rofi/themes/default.rasi) && exit 0


for arg in "$@"
do
    output=$(echo $arg | awk -F':' '{print $1}')
    place=$(echo $arg | awk -F':' '{print $2}')

    case $place in
        "u" | "up")    POSITION="--pos 0x-1080" ;;
        "d" | "down")  POSITION="--pos 0x1080" ;;
        "l" | "left")  POSITION="--pos -1920x0" ;;
        "r" | "right") POSITION="--pos 1920x0" ;;

        "o" | "off")   
            POSITION="--off"
            MODE=""
            ;;

        *) POSITION="--pos 0x0" ;;
    esac
    
    case $output in
        "l" | "lap" | "laptop") xrandr $EDP1 $MODE $POSITION ;;
        "h" | "hdmi") xrandr $HDMI $MODE $POSITION ;;
    esac
done

# restart i3 for reload polybar
i3-msg restart
