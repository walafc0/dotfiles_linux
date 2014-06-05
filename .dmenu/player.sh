#!/bin/bash

if test "X`pgrep cmus`" != "X" ; then

  STATUS=$(cmus-remote -Q | grep status | awk '{print $2}')

  if [ $STATUS == "stopped" ]; then
    exit 0
  fi

    TIME="$(cmus-remote -Q |awk '/duration/ {print $2}')"
    
    if [ $TIME -gt 59 ]; then 
      TIME="$((TIME / 60))m$((TIME % 60))s"
    else
      TIME="$(echo $TIME)s"
    fi

    CURR="$(cmus-remote -Q |awk '/position/ {print $2}')"
    if [ $CURR -gt 59 ]; then
      CURR="$((CURR / 60))m$((CURR % 60))s"
    else
      CURR="$(echo $CURR)s"
    fi

    
    ARTIST="$(cmus-remote -Q |sed -ne '/artist/s/tag artist //pg')"
    TITLE="$(cmus-remote -Q |sed -ne '/title/s/tag title //pg')"
    NUM="$(cmus-remote -Q |sed -ne '/tracknumber/s/tag tracknumber //pg')"
    ALBUM="$(cmus-remote -Q |sed -ne '/album/s/tag album //pg')"

    SHUFF="$(cmus-remote -Q |sed -ne '/shuffle/s/set shuffle //pg')"
    RPT="$(cmus-remote -Q |sed -ne '/repeat_current/s/set repeat_current //pg')"
    STATUS=$(cmus-remote -Q | grep status | awk '{print $2}')

    if [ $SHUFF = "true" ]; then
      OPT="Shuffle"
    fi
    if [ $RPT = "true" ]; then
      if [ -z $OPT ]; then
	OPT="Repeat"
      else
        OPT="$OPT|Repeat"
      fi
    fi
    if [ $STATUS = "paused" ]; then
      if [ -z $OPT ]; then
        OPT="Paused"
      else
        OPT="$OPT|Paused"
      fi
    fi
    
    FINAL=$(echo "$NUM - $TITLE by $ARTIST on $ALBUM - $CURR/$TIME")
    if [ -z $OPT ]; then
      echo $FINAL
    else
      FINAL="$FINAL - $OPT"
      echo $FINAL
    fi
fi

exit 0
