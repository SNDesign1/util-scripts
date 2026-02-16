#!/bin/bash

ip="$1"
username="$2"
password="$3"

if [ ! -f /etc/samba/smb.conf ]; then
    echo "Run: sudo mkdir -p /etc/samba && sudo touch /etc/samba/smb.conf"
    exit 1
fi

if [ -z "$ip" ] || [ -z "$username" ] || [ -z "$password" ]; then
  echo "Usage: $0 <ip> <username> <password>"
  exit 1
fi

if ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "invalid IP address format"
  exit 1
fi

net rpc shutdown -I "$ip" -U "$username%$password"
