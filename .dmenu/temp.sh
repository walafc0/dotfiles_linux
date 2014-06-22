#!/bin/bash

TEMP=$(sensors | grep "Core" | awk '{print $3}' | tr -d '=+=' | tr -d '=°C' )
TEMP=$(bc -q <(echo -e "scale=1\n ($(echo $TEMP | awk '{print $1}')+$(echo $TEMP | awk '{print $2}'))/2\n quit"))
TEMP="Temp:$TEMP°C"

echo $TEMP

