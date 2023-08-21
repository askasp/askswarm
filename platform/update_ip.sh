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
if [[ -z "$CURRENT_IP" ]]; then
    echo "Failed to get the current IP"
    exit 2
fi

# Fetch the current A record for the domain
DNS_IP=$(curl -s -X GET "https://api.godaddy.com/v1/domains/$DOMAIN/records/A/@" \
            -H "Authorization: sso-key $API_KEY:$API_SECRET" \
            -H "Content-Type: application/json" | jq -r '.[0].data')

# Exit if the IP hasn't changed
if [[ "$DNS_IP" == "$CURRENT_IP" ]]; then
    echo "IP address hasn't changed. Skipping update."
    exit 0
fi

# Define the function to update DNS
update_dns() {
    local NAME="$1"
    local TYPE="$2"
    local DATA="$3"

    RESPONSE=$(curl -s -X PUT "https://api.godaddy.com/v1/domains/$DOMAIN/records/$TYPE/$NAME" \
                    -H "Authorization: sso-key $API_KEY:$API_SECRET" \
                    -H "Content-Type: application/json" \
                    -d "[{\"data\": \"$DATA\"}]" )

    # Check the response for errors
    if [[ $RESPONSE == *"message"* ]]; then
        echo "Error updating $NAME.$DOMAIN: $RESPONSE"
    else
        echo "Updated $NAME.$DOMAIN to IP: $CURRENT_IP"
    fi
}

# Update the main domain and wildcard subdomain
update_dns "@" "A" "$CURRENT_IP"
update_dns "*" "A" "$CURRENT_IP"
