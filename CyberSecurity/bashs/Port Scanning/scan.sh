#!/bin/bash
#scan.sh -> the main script


if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> [TIME_SPEED] [SCAN_TYPE] [START_PORT] [END_PORT]"
    exit 1
fi

IP_ADDRESS=$1
TIME_SPEED=$2    
SCAN_TYPE=${3:-sS}   
START_PORT=${4:-1}   
END_PORT=${5:-1000}  

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
sudo ./nmap.sh $IP_ADDRESS $TIME_SPEED $SCAN_TYPE $START_PORT $END_PORT | tee -a "$REPORT_FILE"

# Step 2: Check open web ports
echo "[*] Checking for open ports..." 
node xml_service.js -c 

# Step 3: Run Gobuster for open web ports
sudo ./gobuster.sh $IP_ADDRESS 

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
# Step 7: Cleaning Report from Nonalphnumeric characters.
sudo ./clean_report.sh
# Step 8 : Creating a PDF file for the scan_report
sudo python textToPdf.py