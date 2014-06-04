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

DMENU=$HOME/.dmenu
while true;
do
    PLAYER=$(cat $HOME/.cmus/now-playing)

    NETWORK=$($DMENU/network.sh)
    LOCALTIME=$($DMENU/localtime.sh)
    POWER=$($DMENU/power.sh)
    TEMP=$($DMENU/temp.sh)
    VOL=$($DMENU/vol.sh)

    xsetroot -name "$PLAYER $NETWORK | $POWER | $TEMP | $VOL | $LOCALTIME"
    sleep 1s
done &

wmname LG3D
feh --bg-max $HOME/Pictures/wallpaper
setxkbmap -layout fr -option terminate:ctrl_alt_bksp
urxvtd -q -f -o

# Add $PATH to dmenu
export PATH=$SCRIPTS_DIR:$PATH
export SUDO_ASKPASS=$SCRIPTS_DIR/dmenu_passwd

exec /usr/bin/dwm &> $HOME/.dwm/log
