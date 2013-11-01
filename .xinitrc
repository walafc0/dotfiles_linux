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

    LOCALTIME=$( date +"%m/%d/%y %R" )
    IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)
    TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
    xsetroot -name "$PLAYER $IP | Temp:$TEMP | Vol:$VOL | $LOCALTIME"
    sleep 1s
done &

wmname LG3D
feh --bg-center $HOME/Gallery/wallpaper.jpg
setxkbmap -layout fr -option terminate:ctrl_alt_bksp
numlockx on

# Add $PATH to dmenu
export PATH=$PATH:$HOME/.scripts

exec /usr/bin/dwm &> $HOME/.dwm/log
