#!/bin/bash

# Usage: ./ftp.sh <IP_ADDRESS>
if [ -z "$1" ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

OUTPUT_DIR="scan_results"
TEXT_OUTPUT="$OUTPUT_DIR/ftp.txt"
IP_ADDRESS=$1

# Create a directory to store results
mkdir -p $OUTPUT_DIR

# Attempt anonymous FTP login
echo "Attempting anonymous FTP login to $IP_ADDRESS..."

# Use ftp in batch mode (-n prevents auto login, and -v is verbose output)
ftp -nv $IP_ADDRESS << EOF > $TEXT_OUTPUT
user anonymous anonymous
quit
EOF

# Check if the login was successful by searching the output for "Login successful"
if grep -q "Login successful" $TEXT_OUTPUT; then
  echo "Anonymous FTP login to $IP_ADDRESS succeeded!"
else
  echo "Anonymous FTP login to $IP_ADDRESS failed."
fi

# Clean up
rm ftp_output.txt
