#!/bin/bash

MEM=$(free -m | grep '^Mem' | awk '{print $2 "MB Used: " $3"MB"}')
UP=$(uptime | awk '{print $3}' | tr -d ',')
CPU=$(top -bn 1 | grep -i '^%CPU' | tr -d 'usy,' | awk '{print $2"%U " $3"%S"}')
if [ $UP -lt 60 ]; then
  UP="$(echo $UP)m"
else
  UP="$((UP / 60 ))h$((UP % 60))m"
fi

CPU="CPU usage: $CPU"
MEM="Memory: $MEM"
UP="Uptime: $UP"

FINAL="$CPU | $MEM | $UP"

echo $FINAL
