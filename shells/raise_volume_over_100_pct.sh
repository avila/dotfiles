# #! /bin/bash
# # a script to raise (lower) volume over 100%
#     echo $1

# if [ "$1" = "up" ];then
#     echo "volume up"
#     pactl set-sink-volume 0 +15%
# elif [ "$1" = "down" ]; then
#     echo "volume down"
#     pactl set-sink-volume 0 -30%
# else echo "arg not there?"
# fi
#####################################################################

#!/bin/sh
# Adjust the volume, play a sound, and show a notification.
#
# Replacement for default Ubuntu volume adjustment behaviour.
#
# Based on https://askubuntu.com/a/12769/301745

command=""
device="pulse"
display_volume=0
icon_name="error"
increment=5
mixer="Master"
usage="usage: $0 [-d device] [-i increment] [-m mixer] (up|down|mute)"

# For compatibility with SSH sessions.
export DISPLAY=:0

_amixer(){
    # amixer alias
    local set_get="$1"
    shift
    amixer -D "$device" "$set_get" "$mixer" "$@"
}

_get_display_volume(){
    # grep alias
    grep -Pom 1 '(?<=\[)[0-9]+(?=%\])'
}

while getopts d:hi:m: opt; do
    case "$opt" in
        d)
            device="$OPTARG"
            ;;
        h)
            echo "$usage"
            exit 0
            ;;
        i)
            increment="$OPTARG"
            ;;
        m)
            mixer="$OPTARG"
            ;;
        ?)
            echo "$usage"
            exit 1
            ;;
    esac
done

shift "$(($OPTIND - 1))"
command="$1"

case "$command" in
    down)
        display_volume=10
        pactl set-sink-volume 0 -10%
        ;;
    up)
        display_volume=10
            pactl set-sink-volume 0 +10%
        ;;
    *)
        echo "$usage"
        exit 1
        ;;
esac

if [ "$icon_name" = "error" ]; then
    if [ "$display_volume" = "0" ]; then
        icon_name="notification-audio-volume-off"
    elif [ "$display_volume" -lt "33" ]; then
        icon_name="notification-audio-volume-low"
    elif [ "$display_volume" -lt "67" ]; then
        icon_name="notification-audio-volume-medium"
    else
        icon_name="notification-audio-volume-high"
    fi

    # In a subshell in the background to minimize latency.
    # ( canberra-gtk-play --id=audio-volume-change & )
fi

notify-send "Volume: $display_volume%" -i "$icon_name" -h "string:synchronous:volume" -h "int:value:$display_volume" $command