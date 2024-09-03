#!/bin/bash

# Usage: ./scan_script.sh <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]
if [ "$#" -lt 3 ]; then
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

# Create a directory to store results
mkdir -p $OUTPUT_DIR

# Step 1: Full Port Scan using nmap with service detection and version detection
echo "[*] Running full port scan on $IP_ADDRESS..."
nmap "-s$SCAN_TYPE" -sV "-T$TIME_SPEED" "-p $START_PORT-$END_PORT" -v -A $IP_ADDRESS -oN "$TEXT_OUTPUT" -oX "$XML_OUTPUT"

# Step 2: Parse XML file with Node.js script
echo "[*] Parsing XML file with Node.js script..."
node $NODE_SCRIPT

# Step 3: Running Searchsploit for found services and versions
echo "[*] Searching for CVEs with Searchsploit..."

# Run Searchsploit for each line in output.txt
while IFS= read -r line; do
    echo "[*] Searching for CVEs for $line..."
    searchsploit "$line" -w >> "$REPORT_FILE"
done < "$OUTPUT_DIR/output.txt"

# Step 4: Running gobuster to discover directories on the server
echo "[*] Running gobuster on $IP_ADDRESS..."
gobuster dir -u http://$IP_ADDRESS -w /usr/share/wordlists/dirb/common.txt -o "$OUTPUT_DIR/gobuster_results.txt"

# Step 5: Combine gobuster results with the report
echo "[*] Adding gobuster results to the report..."
cat "$OUTPUT_DIR/gobuster_results.txt" >> "$REPORT_FILE"

echo "[*] Scan complete. Results saved to $REPORT_FILE"
