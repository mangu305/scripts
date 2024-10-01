#!/bin/bash

# Check if running with sufficient permissions
if [ "$EUID" -ne 0 ]; then
   echo "Please run as root"
   exit 1
fi

# Path to the hosts file
hosts_file="/etc/hosts"

# Function to get IP addresses and hostnames from the hosts file
get_entries() {
    awk '{print $1,$2}' "$hosts_file" | grep -v '^#' | grep -v '^$'
}

# Function to add a new entry
add_entry() {
    local ip="$1"
    local hostname="$2"
    
    if ! grep -q "^$ip.*$hostname$" "$hosts_file"; then
        echo "$ip $hostname" | sudo tee -a "$hosts_file" > /dev/null
        echo "Added $ip $hostname to $hosts_file"
    else
        echo "$ip $hostname already exists in $hosts_file"
    fi
}

# Function to update an existing entry
update_entry() {
    local ip="$1"
    local hostname="$2"
    
    if grep -q "^$ip.*$hostname$" "$hosts_file"; then
        local line=$(grep "^$ip.*$hostname$" "$hosts_file")
        echo "$ip $hostname" | sudo tee -a "$hosts_file" > /dev/null
        echo "Updated $ip $hostname in $hosts_file"
    else
        echo "$ip $hostname not found in $hosts_file"
    fi
}

# Main execution
existing_entries=($(get_entries))

while true; do
    read -p "Enter IP address (or 'exit' to quit): " ip
    read -p "Enter hostname: " hostname
    
    if [ "$ip" = "exit" ]; then
        break
    fi
    
    case "$ip" in
        127.0.0.1)
            echo "Local loopback address, skipping"
            continue
            ;;
        *)
            if [ -n "$ip" ] && [ -n "$hostname" ]; then
                if [ -n "$ip" ] && [ -n "$hostname" ]; then
                    add_entry "$ip" "$hostname"
                elif [ -n "$hostname" ]; then
                    # Find matching IP
                    matching_ip=$(grep -oP "(?<=^$hostname).*" "$hosts_file")
                    if [ -n "$matching_ip" ]; then
                        update_entry "$matching_ip" "$hostname"
                    else
                        echo "No matching IP found for $hostname"
                    fi
                else
                    echo "IP or hostname cannot be empty"
                fi
            else
                echo "Both IP and hostname must be provided"
            fi
            ;;
    esac
done
