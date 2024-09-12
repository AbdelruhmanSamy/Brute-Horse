#!/bin/bash

# Usage: ./smb.sh <IP_ADDRESS>
if [ -z "$1" ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

OUTPUT_DIR="scan_results"
TEXT_OUTPUT="$OUTPUT_DIR/smb.txt"
IP_ADDRESS=$1

# Create a directory to store results
mkdir -p $OUTPUT_DIR

# Attempt anonymous SMB login using smbclient
echo "Attempting anonymous SMB login to $IP_ADDRESS..."

# Try to list available shares anonymously
smbclient -L \\$IP_ADDRESS -N > $TEXT_OUTPUT 2>&1

# Check if anonymous login was successful by searching the output for "Anonymous login successful"
if grep -q "Anonymous login successful" $TEXT_OUTPUT || grep -q "NT_STATUS_OK" $TEXT_OUTPUT; then
  echo "Anonymous SMB login to $IP_ADDRESS succeeded!"
else
  echo "Anonymous SMB login to $IP_ADDRESS failed."
fi

# Clean up
rm $TEXT_OUTPUT
