#!/bin/bash

TEMP1="$(($(cat /sys/class/hwmon/hwmon0/device/temp2_input) / 1000))"
TEMP2="$(($(cat /sys/class/hwmon/hwmon0/device/temp4_input) / 1000))"
TEMP="$(bc -q <(echo -e "scale=1\n ($TEMP1+$TEMP2)/2\n quit"))"

TEMP="Temp:$TEMP°C"
echo $TEMP

