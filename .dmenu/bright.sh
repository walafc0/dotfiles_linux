#!/bin/bash

BRIGHT=$(xbacklight | cut -d'.' -f1)
BRIGHT="Brightness:$BRIGHT%"

echo $BRIGHT
