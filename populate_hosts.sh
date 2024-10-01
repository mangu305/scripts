#!/bin/bash

# Backup the current hosts file
cp /etc/hosts /etc/hosts.bak

# Define the source of host entries (you can modify this)
SOURCE="https://example.com/hosts.txt" # Replace with your actual source

# Fetch host entries
echo "Fetching host entries from $SOURCE..."
curl -s "$SOURCE" -o /tmp/hosts.txt

if [ $? -ne 0 ]; then
    echo "Error fetching host entries. Exiting."
    exit 1
fi

# Populate /etc/hosts
echo "Populating /etc/hosts..."
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    echo "$line" | sudo tee -a /etc/hosts > /dev/null
done < /tmp/hosts.txt

echo "Hosts file updated successfully."

# Cleanup
rm /tmp/hosts.txt
