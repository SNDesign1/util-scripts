#!/bin/bash

mac_address=$1

# Check if mac_address argument was provided
if [ -z "$mac_address" ]; then
  echo "mac_address was invalid"
  exit 1
fi

# Validate MAC address format
if ! [[ "$mac_address" =~ ^([a-fA-F0-9]{2}[:-]){5}[a-fA-F0-9]{2}$ ]]; then
  echo "invalid mac address format"
  exit 1
fi

# Check if wakeonlan is installed
if ! command -v wakeonlan >/dev/null 2>&1; then
  echo "wakeonlan is not installed"
  echo "Install it with: sudo pacman -S wakeonlan"
  exit 1 
fi

wakeonlan "$mac_address"
exit 0
