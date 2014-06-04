#!/bin/bash

BATTERY=$(acpi -b | awk '{ split($5,a,":"); print substr($3,0,11), $4, "["a[1]":"a[2]"]" }' | tr -d ',')

if [ -z $BATTERY ]; then
  BATTERY="Battery is unplugged"
else
  BATTERY="Battery is $BATTERY"
fi

ADAPTER=$(acpi -a | awk '{ split($5,a,":"); print substr($3,0,11),$4}' | tr -d ',')

if [ $ADAPTER = "on-line" ]; then
  ADAPTER="Connected to AC"
  echo "$ADAPTER - $BATTERY"
else
  echo "$BATTERY"
fi

exit 0


