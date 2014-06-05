#!/bin/bash

# if VPN is on
if ifconfig | grep tun0 > /dev/null; then
  # IP=$(ifconfig | grep -A1 tun0 | tail -n1 | awk '{print $2}')
  IP=$(ip r | grep $(ip r | grep default | awk '{print $3}') | grep -v src | tail -n1 | awk '{print $1}')
  VPN="[vpn on]"

else
  IP=$(ip r | tail -n1 | awk '{print $9}')
  VPN="[vpn off]"
fi

DEV="$(ip r | grep kernel | tail -n1 | awk '{print $3}')"
NET="$IP on $DEV $VPN"
echo $NET

