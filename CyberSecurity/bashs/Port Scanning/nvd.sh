#!/bin/bash
#nvd.sh

OUTPUT_DIR="scan_results"
INPUT_FILE="$OUTPUT_DIR/servicesOutput.txt"
NVD_OUTPUT="$OUTPUT_DIR/nvd_output.txt"
REPORT_FILE="$OUTPUT_DIR/scan_report.txt"

> "$NVD_OUTPUT"

while IFS= read -r service; do
    echo "[*] Searching NVD for $service..." | tee -a "$REPORT_FILE"
    
    # URL encode service
    encoded_service=$(echo "$service" | sed 's/ /+/g')
    url="https://nvd.nist.gov/vuln/search/results?query=${encoded_service}"

    html_content=$(curl -s "$url")
    
    output=$(echo "$html_content" | awk '
    BEGIN { RS="<tr data-testid=\"vuln-row-"; FS="</tr>" }
    {
        if (NR > 1) {
            row = $0;
            split(row, arr, "</a>");
            vuln_id = substr(arr[1], index(arr[1], "/vuln/detail/") + 14);
            gsub(/[^a-zA-Z0-9\-]/, "", vuln_id);
            description = gensub(/.*<p data-testid="vuln-summary-[0-9]+">([^<]*)<\/p>.*/, "\\1", "g", row);
            link = "https://nvd.nist.gov/vuln/detail/" vuln_id;
            print "VulnID:" vuln_id;
            print "Description:" description;
            print "Link:" link;
            print "";
        }
    }')

    if [ -n "$output" ]; then
        echo "$output" >> "$REPORT_FILE"
    else
        echo "No vulnerabilities found for $service." >> "$REPORT_FILE"
    fi

done < "$INPUT_FILE"
