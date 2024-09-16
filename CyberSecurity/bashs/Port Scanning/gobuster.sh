#!/bin/bash
# gobuster.sh - Run Gobuster for open web server ports

IP_ADDRESS=$1
OUTPUT_DIR="scan_results"
PORTS_FILE="$OUTPUT_DIR/portsOutput.txt"
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"

if [ ! -f "$PORTS_FILE" ]; then
    echo "Error: $PORTS_FILE not found!"
    exit 1
fi

declare -A seen_ports

while IFS= read -r line; do
    port=$(echo "$line")
    if [[ -n "$port" && -z "${seen_ports[$port]}" ]]; then
        echo "[*] Running gobuster on port $port..."
        gobuster_output_file="$OUTPUT_DIR/port${port}_output.txt"
        gobuster dir -u http://$IP_ADDRESS:$port -w /usr/share/wordlists/dirb/common.txt -o "$gobuster_output_file"
        echo "[*] Adding gobuster results for port $port to the report..."
        echo "Gobuster results for port $port:" >> "$REPORT_FILE"
        cat "$gobuster_output_file" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        seen_ports["$port"]=1
    fi
done < "$PORTS_FILE"

echo "[*] Gobuster scan complete. Results saved."
