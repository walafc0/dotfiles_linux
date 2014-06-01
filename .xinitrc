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

    # TOFIX
    if [ -z $VOL ]; then
      VOL=$(amixer | tail -n1 | awk '{print $5}' | sed 's/.*\[\([0-9]*%\)\].*/\1/')
    fi

    if [ "$MUTE" != "" ]; then
        VOL="$VOL [muted]"
    fi

    if [ $(pidof openvpn) ]; then
      IP=$(ip r | grep $(ip r | grep default | awk '{print $3}') | tail -n1 | awk '{print $1}')
      if [ "$IP" = "default" ]; then
        IP="Connecting..."
      else
        IP="$IP [vpn on]"
      fi
    else
      IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)
      IP="$IP [vpn off]"
    fi
    if [ -z $IP ]; then
      IP="Not connected"
    fi

    LOCALTIME=$( date +"%a %m/%d/%Y %R" )
    TEMP1="$(($(cat /sys/class/hwmon/hwmon0/device/temp2_input) / 1000))"
    TEMP2="$(($(cat /sys/class/hwmon/hwmon0/device/temp4_input) / 1000))"
    TEMP="$(bc -q <(echo -e "scale=1\n ($TEMP1+$TEMP2)/2\n quit"))°C"

    BATTERYSTATE=$(acpi -b | awk '{ split($5,a,":"); print substr($3,0,11), $4, "["a[1]":"a[2]"]" }' | tr -d ',')
    if [ -z $BATTERYSTATE ]; then
      BATTERYSTATE="unplugged"
    fi

    xsetroot -name "$PLAYER $IP | Battery: $BATTERYSTATE | Temp:$TEMP | Vol:$VOL | $LOCALTIME"
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
