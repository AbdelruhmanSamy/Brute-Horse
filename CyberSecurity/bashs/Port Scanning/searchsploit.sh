#!/bin/bash
#searchsploit.sh

OUTPUT_DIR="scan_results"
INPUT_FILE="$OUTPUT_DIR/servicesOutput.txt"
SEARCHSPLIT_OUTPUT="$OUTPUT_DIR/search_sploit_output.txt"
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"

> "$SEARCHSPLIT_OUTPUT"

while IFS= read -r service; do
    echo "[*] Searching for vulnerabilities in $service..." | tee -a "$REPORT_FILE"
    searchsploit "$service" -w >> "$SEARCHSPLIT_OUTPUT"
    echo "Searchsploit results for $service:" >> "$REPORT_FILE"
    cat "$SEARCHSPLIT_OUTPUT" >> "$REPORT_FILE"
done < "$INPUT_FILE"
