#!/bin/bash

# if VPN is on
if ifconfig | grep tun0 > /dev/null; then
  IP=$(ip r | grep kernel  | tail -n1 | awk '{print $9}')
  VPN="[vpn on]"
else
  IP=$(ip r | grep kernel  | awk '{print $9}')
  VPN="[vpn off]"
fi

if [ ! -z $IP ]; then
  DEV="$(ip r | grep kernel | tail -n1 | awk '{print $3}')"
  NET="$IP on $DEV $VPN"
else
  NET="Disconnected"
fi

echo $NET

