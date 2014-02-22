#!/bin/bash

xset +fp /usr/share/fonts/local
xset fp rehash
xset -b

if [ -s ~/.Xresources ]; then
    xrdb -merge $HOME/.Xresources
fi

if [ -s ~/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

while true;
do
    PLAYER=$(cat $HOME/.cmus/now-playing)
    MUTE=$(amixer get Master | tail -1 | grep off)
    VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')

    if [ "$MUTE" != "" ]; then
        VOL="$VOL [muted]"
    fi

    LOCALTIME=$( date +"%a %m/%d/%Y %R" )
    IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)
    TEMP1="$(($(cat /sys/class/hwmon/hwmon0/device/temp2_input) / 1000))"
    TEMP2="$(($(cat /sys/class/hwmon/hwmon0/device/temp4_input) / 1000))"
    TEMP="$(bc -q <(echo -e "scale=1\n ($TEMP1+$TEMP2)/2\n quit"))°C"

    BATTERYSTATE=$(acpi -b | awk '{ split($5,a,":"); print substr($3,0,11), $4, "["a[1]":"a[2]"]" }' | tr -d ',')
    if [ -z $BATTERYSTATE ]; then
      BATTERYSTATE="unplugged"
    fi

    if [ -z $IP ]; then
      IP="Not connected"
    fi

    xsetroot -name "$PLAYER $IP | Battery: $BATTERYSTATE | Temp:$TEMP | Vol:$VOL | $LOCALTIME"
    sleep 1s
done &

wmname LG3D
#feh --bg-scale $HOME/Pictures/wallpaper
setxkbmap -layout fr -option terminate:ctrl_alt_bksp

# Add $PATH to dmenu
export PATH=$HOME/.scripts:$PATH

exec /usr/bin/dwm &> $HOME/.dwm/log
