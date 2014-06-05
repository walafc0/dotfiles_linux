#!/bin/bash

# TRACK=$(cat $HOME/.cmus/now-playing)

# echo "$TRACK"

if test "X`pgrep cmus`" != "X" ; then 
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
    SHUFF="Shuffle: $SHUFF"
    RPT="$(cmus-remote -Q |sed -ne '/repeat_current/s/set repeat_current //pg')"
    RPT="Repeat: $RPT"

    echo "$NUM - $TITLE - $ARTIST on $ALBUM - $CURR/$TIME - $SHUFF - $RPT"
fi
