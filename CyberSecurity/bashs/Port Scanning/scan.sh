#!/bin/bash
#scan.sh -> the main script

# Default values
VERBOSE=false

# Check for the '-v' flag
for arg in "$@"; do
    if [ "$arg" == "-v" ]; then
        VERBOSE=true
        break
    fi
done

# Remove the '-v' flag from the arguments passed to nmap.sh if it exists
args=("$@")
for i in "${!args[@]}"; do
    if [ "${args[$i]}" == "-v" ]; then
        unset 'args[$i]'
    fi
done

if [ "${#args[@]}" -lt 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]"
    exit 1
fi

IP_ADDRESS=${args[0]}
TIME_SPEED=${args[1]}
SCAN_TYPE=${args[2]:-sS}
START_PORT=${args[3]:-1}
END_PORT=${args[4]:-1000}

OUTPUT_DIR="scan_results"
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"

sudo rm -r $OUTPUT_DIR
mkdir $OUTPUT_DIR

# Create a readable report header
echo "### Penetration Test Report for $IP_ADDRESS ###" > "$REPORT_FILE"
echo "Scan type: $SCAN_TYPE, Ports: $START_PORT-$END_PORT, Speed: $TIME_SPEED" >> "$REPORT_FILE"
echo "--------------------------------------------" >> "$REPORT_FILE"

# Step 1: Full Port Scan using nmap
echo "[*] Running Nmap scan on $IP_ADDRESS..." | tee -a "$REPORT_FILE"
if [ "$VERBOSE" = true ]; then
    sudo ./nmap.sh "$IP_ADDRESS" "$TIME_SPEED" "$SCAN_TYPE" "$START_PORT" "$END_PORT" -v | tee -a "$REPORT_FILE"
else
    sudo ./nmap.sh "$IP_ADDRESS" "$TIME_SPEED" "$SCAN_TYPE" "$START_PORT" "$END_PORT" | tee -a "$REPORT_FILE"
fi

# Step 2: Check open web ports
echo "[*] Checking for open ports..."
node xml_service.js -c

# Step 3: Run Gobuster for open web ports
sudo ./gobuster.sh "$IP_ADDRESS"

# Step 4: Extract service details
echo "[*] Extracting service details..."
node xml_service.js -t

# Step 5: Searchsploit for services
echo "[*] Searching vulnerabilities with Searchsploit..."
sudo ./searchsploit.sh

# Step 6: NVD DB vulnerability search
echo "[*] Checking NVD Database for vulnerabilities..."
sudo ./nvd.sh

echo "### Report Complete ###" >> "$REPORT_FILE"
echo "Results saved in $REPORT_FILE"

# Step 7: Cleaning Report from Non-alphanumeric characters
sudo ./clean_report.sh
