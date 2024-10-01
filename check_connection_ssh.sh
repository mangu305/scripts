#!/bin/bash

# Define the hosts file (modify this to your actual hosts file)
HOSTS_FILE="/etc/hosts" # Change this if needed
SSH_USER="your_username" # Replace with your SSH username

# Check if the hosts file exists
if [[ ! -f "$HOSTS_FILE" ]]; then
    echo "Hosts file not found: $HOSTS_FILE"
    exit 1
fi

# Function to check SSH connectivity
check_ssh_connectivity() {
    local host="$1"
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$SSH_USER@$host" exit 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "$host is reachable via SSH"
    else
        echo "$host is not reachable via SSH"
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
        check_ssh_connectivity "$host"
    fi
done < "$HOSTS_FILE"
