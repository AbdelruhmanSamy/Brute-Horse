#!/bin/bash

# Usage: ./scan_script.sh <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]"
    exit 1
fi

IP_ADDRESS=$1
TIME_SPEED=$2    
SCAN_TYPE=${3:-sS}   # Default scan type to sS (SYN scan) if not provided
START_PORT=${4:-1}   # Default start port to 1 if not provided
END_PORT=${5:-1000}  # Default end port to 1000 if not provided
OUTPUT_DIR="scan_results"
TEXT_OUTPUT="$OUTPUT_DIR/nmap_scan.txt"
XML_OUTPUT="$OUTPUT_DIR/nmap_scan.xml"
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"
NODE_SCRIPT="xml_service.js"  # Update this with the path to your Node.js script

sudo rm -r $OUTPUT_DIR
# Create a directory to store results
mkdir  $OUTPUT_DIR

# Step 1: Full Port Scan using nmap with service detection and version detection
sudo ./nmap.sh $IP_ADDRESS $TIME_SPEED $SCAN_TYPE $START_PORT $END_PORT
# Step 2: Parse XML file with Node.js script to check open ports (-c)
echo "[*] Checking for open web servers..."
node $NODE_SCRIPT -c 
# Step 3: Running GoBuster for open Webservers ports.
sudo ./gobuster.sh $IP_ADDRESS

# Step 4: Parse XML file with Node.js script to extract service details (-t)
echo "[*] Extracting service details from open ports..."
node $NODE_SCRIPT -t  # Pass '-t' for extracting service details

# Step 5: Running Searchsploit for found services and versions
sudo ./searchsploit.sh

# Step 6: Running Search at NIST DB for found services and versions
sudo ./nvd.sh