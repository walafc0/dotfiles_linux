#!/bin/bash
# SETTINGS
NOW_PLAYING_PIPE="$HOME/.cmus/now-playing"

title=""
artist=""
stat="stopped"

while [ "$1" '!=' "" ]
do
	case "$1" in
		title)
			title="$2"
		;;
		artist)
			artist="$2"
		;;
		status)
			stat="$2"
		;;
		*)
		;;
	esac
	shift
	shift
done

msg=""
if [ "$stat" '=' 'stopped' ]
then
    $msg=""
else
	if [ "$stat" '=' 'paused' ]
	then
		msg="[paused] "
	fi

	if [ -n "$title" ]
	then
		msg="$msg$title "
	fi

	if [ -n "$artist" ]
	then
		msg="$msg- $artist |"
	else
	    $msg="$msg |"
	fi
fi

echo "$msg" > "$NOW_PLAYING_PIPE"
