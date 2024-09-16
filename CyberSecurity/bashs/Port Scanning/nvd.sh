#!/bin/bash

# Define variables
OUTPUT_DIR="scan_results"
INPUT_FILE="$OUTPUT_DIR/servicesOutput.txt"
NVD_OUTPUT="$OUTPUT_DIR/nvd_output.txt"

# Ensure the output file is empty before starting
> "$NVD_OUTPUT"

# Loop through each line in the input file
while IFS= read -r service; do
    # Check if the service is not empty
    if [ -n "$service" ]; then
        echo "[*] Searching for vulnerabilities for service: $service" >> "$NVD_OUTPUT"
        
        # URL encode the service name (replacing spaces with '+')
        encoded_service=$(echo "$service" | sed 's/ /+/g')

        # NVD search URL with the service name inserted
        url="https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=${encoded_service}&search_type=all&isCpeNameSearch=false"

        # Fetch the HTML content of the search results page
        html_content=$(curl -s "$url")

        # Extract VulnID, Description, and Links
        output=$(echo "$html_content" | awk '
        BEGIN { RS="<tr data-testid=\"vuln-row-"; FS="</tr>" }
        {
            if (NR > 1) {
                row = $0;
                split(row, arr, "</a>");
                vuln_id = substr(arr[1], index(arr[1], "/vuln/detail/") + 14);
                gsub(/[^a-zA-Z0-9\-]/, "", vuln_id);
                while (substr(vuln_id, 1, 1) != "C") {
                    vuln_id = substr(vuln_id, 2);
                }
                description = gensub(/.*<p data-testid="vuln-summary-[0-9]+">([^<]*)<\/p>.*/, "\\1", "g", row);
                link = "https://nvd.nist.gov/vuln/detail/" vuln_id;
                gsub(/^[ \t]+|[ \t]+$/, "", description);  # Trim whitespace
                print "VulnID:"vuln_id;
                print "Description: "description;
                print "Link: "link;
                print "";
            }
        }' | sed 's/^[ \t]*//;s/[ \t]*$//')

        # Check if output is empty
        if [ -z "$output" ]; then
            echo "No vulnerabilities found for $service in NIST DB" >> "$NVD_OUTPUT"
        else
            # If vulnerabilities are found, save them to nvd_output.txt
            echo "$output" >> "$NVD_OUTPUT"
        fi

        echo "" >> "$NVD_OUTPUT"  # Add a blank line between each service's results
    fi
done < "$INPUT_FILE"

echo "[*] NVD search complete. Results saved to $NVD_OUTPUT"
