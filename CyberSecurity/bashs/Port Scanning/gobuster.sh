#!/bin/bash

# Define variables
IP_ADDRESS=$1
OUTPUT_DIR="scan_results"
PORTS_FILE="$OUTPUT_DIR/portsOutput.txt"  # File containing open ports and services
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"

# Ensure the ports file exists
if [ ! -f "$PORTS_FILE" ]; then
    echo "Error: $PORTS_FILE not found!"
    exit 1
fi

# Read each port from the portsOutput.txt file
while IFS= read -r line; do
    # Extract port number from the line (assuming format "Port: <port>, Service: <service>")
    port=$(echo "$line")

    # Check if the port is valid and contains a number
    if [[ -n "$port" ]]; then
        echo "[*] Running gobuster on port $port..."

        # Run gobuster for each port and save the result in ${port}_output.txt
        gobuster_output_file="$OUTPUT_DIR/port${port}_output.txt"
        gobuster dir -u http://$IP_ADDRESS:$port -w /usr/share/wordlists/dirb/common.txt -o "$gobuster_output_file"

        echo "[*] Adding gobuster results for port $port to the report..."
        echo "Gobuster results for port $port:" >> "$REPORT_FILE"
        cat "$gobuster_output_file" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"  # Add a blank line between results for readability
    fi
done < "$PORTS_FILE"

echo "[*] Gobuster scan complete. Results saved in individual port files and $REPORT_FILE."
