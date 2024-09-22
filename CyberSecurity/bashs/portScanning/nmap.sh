#!/bin/bash
#nmap.sh

IP_ADDRESS=$1
TIME_SPEED=$2
SCAN_TYPE=${3:-sS}
START_PORT=${4:-1}
END_PORT=${5:-1000}
OUTPUT_DIR="./scan_results"
XML_OUTPUT="$OUTPUT_DIR/nmap_scan.xml"

VERBOSE=false
if [ "$6" == "-v" ]; then
    VERBOSE=true
fi

echo "Running full port scan on $IP_ADDRESS, Ports $START_PORT-$END_PORT..." | tee -a "$REPORT_FILE"

if [ "$VERBOSE" = true ]; then
    nmap "$SCAN_TYPE" -sV "-T$TIME_SPEED" "-p$START_PORT-$END_PORT" -v $IP_ADDRESS -oX "$XML_OUTPUT"
else
    nmap "$SCAN_TYPE" -sV "-T$TIME_SPEED" "-p$START_PORT-$END_PORT" $IP_ADDRESS -oX "$XML_OUTPUT"
fi

# Append summary to report
echo "Nmap scan complete." | tee -a "$REPORT_FILE"
