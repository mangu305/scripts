#!/bin/bash

# Define the hosts file (modify this to your actual hosts file)
HOSTS_FILE="/etc/hosts" # You can change this to another file if needed

# Check if the hosts file exists
if [[ ! -f "$HOSTS_FILE" ]]; then
    echo "Hosts file not found: $HOSTS_FILE"
    exit 1
fi

# Function to check connectivity
check_connectivity() {
    local host="$1"
    if ping -c 1 -W 1 "$host" > /dev/null 2>&1; then
        echo "$host is reachable"
    else
        echo "$host is not reachable"
    fi
}

# Read the hosts file and check each host
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Extract the hostname (last field in the line)
    host=$(echo "$line" | awk '{print $2}')
    
    # Check if the host is valid
    if [[ -n "$host" ]]; then
        check_connectivity "$host"
    fi
done < "$HOSTS_FILE"
