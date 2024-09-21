#!/bin/bash
#gobuster.sh

IP_ADDRESS=$1
OUTPUT_DIR="scan_results"
PORTS_FILE="$OUTPUT_DIR/portsOutput.txt"  
REPORT_FILE="$OUTPUT_DIR/portScanning.txt"

# Ensure the ports file exists
if [ ! -f "$PORTS_FILE" ]; then
    echo "Error: Ports file not found!"
    exit 1
fi

# Read each port and run Gobuster
while IFS= read -r port; do
    # echo "[*] Running Gobuster on port $port..." | tee -a "$REPORT_FILE"
    gobuster_output_file="$OUTPUT_DIR/port${port}_output.txt"
    gobuster dir -u http://$IP_ADDRESS:$port -w /usr/share/wordlists/dirb/common.txt -o "$gobuster_output_file"
    
    # Append results to report
    echo "Gobuster Results for port $port:" >> "$REPORT_FILE"
    cat "$gobuster_output_file" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
done < "$PORTS_FILE"
