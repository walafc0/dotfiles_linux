#!/bin/bash

MUTE=$(amixer get Master | tail -1 | grep off)
VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')

# TOFIX
if [ -z $VOL ]; then
    VOL=$(amixer | tail -n1 | awk '{print $5}' | sed 's/.*\[\([0-9]*%\)\].*/\1/')
fi

if [ "$MUTE" != "" ]; then
    VOL="$VOL [muted]"
fi

VOL="Vol:$VOL"
echo $VOL

