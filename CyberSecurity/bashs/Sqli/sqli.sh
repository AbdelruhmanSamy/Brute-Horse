#!/bin/bash

# Colors for terminal output
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

# Check if sqlmap is installed
if ! command -v sqlmap &> /dev/null; then
    echo -e "${RED}sqlmap could not be found. Please install it before running this script.${RESET}"
    exit 1
fi

# Function to show usage
usage() {
    echo -e "${CYAN}Usage: $0 -u URL [-p PARAM] [-D DATABASE] [-T TABLE] [-C COLUMN] [OPTIONS]${RESET}"
    echo ""
    echo "Options:"
    echo "  -u URL        Target URL"
    echo "  -p PARAM      Parameter to test for injection (optional)"
    echo "  -D DATABASE   Specify database name (optional)"
    echo "  -T TABLE      Specify table name (optional)"
    echo "  -C COLUMN     Specify column name (optional)"
    echo "  --options     Additional sqlmap options (optional)"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift ;;
        -p|--param) param="$2"; shift ;;
        -D|--database) database="$2"; shift ;;
        -T|--table) table="$2"; shift ;;
        -C|--column) column="$2"; shift ;;
        --options) options="$2"; shift ;;
        *) echo -e "${RED}Unknown parameter passed: $1${RESET}"; usage ;;
    esac
    shift
done

# Check if URL is provided
if [ -z "$url" ]; then
    echo -e "${RED}Target URL is required.${RESET}"
    usage
fi

# Define the output file in the current directory
output_file="sqlmap_output.log"

# Build the sqlmap command
sqlmap_cmd="sqlmap -u \"$url\" --batch --dbs"

# Add parameter if specified
if [ ! -z "$param" ]; then
    sqlmap_cmd+=" --data=\"$param\""
fi

# Add database, table, and column if specified
if [ ! -z "$database" ]; then
    sqlmap_cmd+=" -D \"$database\""
fi
if [ ! -z "$table" ]; then
    sqlmap_cmd+=" -T \"$table\""
fi
if [ ! -z "$column" ]; then
    sqlmap_cmd+=" -C \"$column\""
fi

# Add any additional options
if [ ! -z "$options" ]; then
    sqlmap_cmd+=" $options"
fi

# Run the sqlmap command and save the output to the specified file
echo -e "${GREEN}Running sqlmap and saving output to $output_file...${RESET}"
eval $sqlmap_cmd > "$output_file" 2>&1

# Check for the database type in the output
db_type=$(grep -oP 'the back-end DBMS is \K\w+' "$output_file")

# Display the database type if found
if [ ! -z "$db_type" ]; then
    echo -e "${CYAN}The back-end DBMS is ${YELLOW}$db_type${RESET}"
else
    echo -e "${RED}Could not detect the database type.${RESET}"
fi

# Check if the output file contains vulnerabilities and display them
echo -e "${YELLOW}Checking for vulnerabilities...${RESET}"

# Extract the vulnerabilities from the output file
vulnerabilities=$(awk '/Parameter: /,/---/' "$output_file")

# Extract the found databases from the output file
databases=$(awk '/available databases/,/^\s*$/' "$output_file")

# Extract dumped databases from the output file
dumped_databases=$(awk '/Database: /, /^\s*$/' "$output_file")

if [ ! -z "$vulnerabilities" ]; then
    echo -e "${CYAN}=== Vulnerabilities Found ===${RESET}"
    echo "$vulnerabilities"
else
    echo -e "${GREEN}No vulnerabilities found.${RESET}"
fi

# Output the extracted information
if [ ! -z "$databases" ];then
    echo -e "${CYAN}=== Extracted Databases ===${RESET}"
    echo -e "$databases"
else
    echo -e "${RED}No databases found.${RESET}"
fi

if [ ! -z "$tables"]; then
    echo -e "${CYAN}=== Extracted Tables ===${RESET}"
    echo -e "$tables"
fi

if [[ "$options" == *dump* ]]; then
    if [ ! -x "$dumped_databases" ]; then
        echo -e "${CYAN}=== Extracted Dumped Data ===${RESET}"
        echo -e "$dumped_databases"
    else
        echo -e "${RED}failed to dump database${RESET}"
    fi
fi


# Notify the user that the output has been saved
echo -e "${CYAN}SQLmap output saved to $output_file${RESET}"
