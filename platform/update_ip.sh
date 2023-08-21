#!/bin/bash

# Ensure the necessary arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <YOUR_API_KEY> <YOUR_API_SECRET>"
    exit 1
fi

# GoDaddy credentials from arguments
API_KEY="$1"
API_SECRET="$2"
DOMAIN="akselerasjon.no"

# Get current public IP address
CURRENT_IP=$(curl -s https://api.ipify.org)

# Define the function to update DNS
update_dns() {
    local NAME="$1"
    local TYPE="$2"
    local DATA="$3"

    curl -X PUT "https://api.godaddy.com/v1/domains/$DOMAIN/records/$TYPE/$NAME" \
         -H "Authorization: sso-key $API_KEY:$API_SECRET" \
         -H "Content-Type: application/json" \
         -d "[{\"data\": \"$DATA\"}]"
}

