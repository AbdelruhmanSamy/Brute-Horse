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

# Step 2: Parse XML file with Node.js script to check open ports (-c)
echo "[*] Checking if ports 80 or 443 are open..."
OPEN_PORTS=$(node $NODE_SCRIPT -c)  # Pass '-c' for checking open ports

if [[ "$OPEN_PORTS" == *"80"* || "$OPEN_PORTS" == *"443"* ]]; then
    # Step 3: Running gobuster if web ports are open
    echo "[*] Port 80 or 443 is open, running gobuster..."
    gobuster dir -u http://$IP_ADDRESS -w /usr/share/wordlists/dirb/common.txt -o "$OUTPUT_DIR/gobuster_results.txt"
    echo "[*] Adding gobuster results to the report..."
    cat "$OUTPUT_DIR/gobuster_results.txt" >> "$REPORT_FILE"
else
    echo "[*] No web server detected (ports 80 or 443 closed). Skipping gobuster."
fi

# Step 4: Parse XML file with Node.js script to extract service details (-t)
echo "[*] Extracting service details from open ports..."
node $NODE_SCRIPT -t  # Pass '-t' for extracting service details

# Step 5: Running Searchsploit for found services and versions
echo "[*] Searching for CVEs with Searchsploit..."

while IFS= read -r line; do
    # Split the product and version
    serviceProduct=$(echo "$line" | awk '{print $1}')
    serviceVersion=$(echo "$line" | awk '{print $2}')

    # Extract major, minor, and patch versions from serviceVersion
    major=$(echo "$serviceVersion" | cut -d '.' -f 1)
    minor=$(echo "$serviceVersion" | cut -d '.' -f 2)
    patch=$(echo "$serviceVersion" | cut -d '.' -f 3)

    echo "[*] Searching for CVEs for $serviceProduct version >= $serviceVersion..."

    # Run searchsploit for the service and filter by version (greater or equal)
    searchsploit "$serviceProduct" -w | awk -v maj="$major" -v min="$minor" -v pat="$patch" '
    {
        # Extract version from the results
        match($0, /[0-9]+\.[0-9]+\.[0-9]+/, version)
        split(version[0], v, ".")

        # Compare versions and print only if the result version >= service version
        if (v[1] > maj || (v[1] == maj && v[2] > min) || (v[1] == maj && v[2] == min && v[3] >= pat)) {
            print $0
        }
    }' >> "$REPORT_FILE"
done < "$OUTPUT_DIR/output.txt"

echo "[*] Scan complete. Results saved to $REPORT_FILE"
