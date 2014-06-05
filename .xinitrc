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
    # Top bar
    NETWORK=$($DMENU/network.sh)
    LOCALTIME=$($DMENU/localtime.sh)
    POWER=$($DMENU/power.sh)
    TEMP=$($DMENU/temp.sh)
    VOL=$($DMENU/vol.sh)
    BRIGHT=$($DMENU/bright.sh)
    # Bottom bar
    PLAYER=$($DMENU/player.sh)
    RESOURCES=$($DMENU/resources.sh)

    xsetroot -name "$NETWORK | $POWER | $TEMP | $VOL | $BRIGHT | $LOCALTIME;$RESOURCES | $PLAYER"

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
