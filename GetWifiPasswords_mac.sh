#!/bin/bash

# Get the list of all Wi-Fi networks stored in the keychain
networks=$(security find-generic-password -D "AirPort network password" -a "$USER" -s "" 2>&1 | grep "acct<blob>=" | cut -d '"' -f 2)

echo "Stored Wi-Fi passwords:"

# Loop through each network and retrieve the password
for network in $networks; do
    password=$(security find-generic-password -D "AirPort network password" -a "$USER" -s "$network" -w 2>/dev/null)
    echo "$network: $password"
done
