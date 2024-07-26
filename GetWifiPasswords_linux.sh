#!/bin/bash

# Directory where NetworkManager stores connection information
connections_dir="/etc/NetworkManager/system-connections/"

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Stored Wi-Fi passwords:"

# Loop through each file in the connections directory
for file in "$connections_dir"*; do
    if [[ -f "$file" ]]; then
        ssid=$(grep '^ssid=' "$file" | cut -d'=' -f2)
        psk=$(grep '^psk=' "$file" | cut -d'=' -f2)
        if [[ -n "$ssid" && -n "$psk" ]]; then
            echo "$ssid: $psk"
        fi
    fi
done
