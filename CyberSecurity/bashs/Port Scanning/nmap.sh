#!/bin/bash

IP_ADDRESS=$1
TIME_SPEED=$2    
SCAN_TYPE=${3:-sS}   # Default scan type to sS (SYN scan) if not provided
START_PORT=${4:-1}   # Default start port to 1 if not provided
END_PORT=${5:-1000}  # Default end port to 1000 if not provided
OUTPUT_DIR="scan_results"
TEXT_OUTPUT="$OUTPUT_DIR/nmap_scan.txt"
XML_OUTPUT="$OUTPUT_DIR/nmap_scan.xml"

echo "[*] Running full port scan on $IP_ADDRESS..."
nmap "-s$SCAN_TYPE" -sV "-T$TIME_SPEED" "-p $START_PORT-$END_PORT" -v -A $IP_ADDRESS -oN "$TEXT_OUTPUT" -oX "$XML_OUTPUT"
