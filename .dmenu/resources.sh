#!/bin/bash

MEM=$(free -m | grep '^Mem' | awk '{print $2 "MB Used: " $3"MB"}')
CPU=$(top -bn 1 | grep -i '^%CPU' | tr -d 'usy,' | awk '{print $2"%U " $3"%S"}')
FSPACE=$(df -h | grep "/home" | awk '{print $4}')
UP=$(uptime | awk '{print $3}' | tr -d ',')

if [ $UP -lt 60 ]; then
  UP="$(echo $UP)m"
else
  UP="$((UP / 60 ))h$((UP % 60))m"
fi

CPU="CPU usage: $CPU"
MEM="Memory: $MEM"
FSPACE="Free space: $(echo $FSPACE)b"
UP="Uptime: $UP"

FINAL="$CPU | $MEM | $FSPACE | $UP"

echo $FINAL
