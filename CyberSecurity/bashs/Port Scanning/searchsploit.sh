#!/bin/bash

# Define variables
OUTPUT_DIR="scan_results"
INPUT_FILE="$OUTPUT_DIR/servicesOutput.txt"
SEARCHSPLIT_OUTPUT="$OUTPUT_DIR/search_sploit_output.txt"

# Ensure output file is empty before starting
> "$SEARCHSPLIT_OUTPUT"

echo "[*] Searching for CVEs with Searchsploit..."

# Read each line from the input file and run searchsploit
while IFS= read -r line; do
    # Check if the line is not empty
    if [ -n "$line" ]; then
        echo "Searching for: $line" >> "$SEARCHSPLIT_OUTPUT"
        searchsploit "$line" -w >> "$SEARCHSPLIT_OUTPUT"
        echo "" >> "$SEARCHSPLIT_OUTPUT"  # Add a blank line between results for readability
    fi
done < "$INPUT_FILE"

echo "[*] Scan complete. Results saved to $SEARCHSPLIT_OUTPUT"
