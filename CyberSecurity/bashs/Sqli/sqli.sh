#!/bin/bash

# Colors for terminal output
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

# Define the temporary files for SQLmap and terminal output
sqlmap_output_file="sqlmap_output.log"
terminal_output_file="terminal_output.log"

# Ensure the temporary files are empty at the start
> "$sqlmap_output_file"
> "$terminal_output_file"

# Function to echo messages to both terminal and temporary file
log() {
    local message="$1"
    echo -e "$message" | tee -a "$terminal_output_file"
}

# Check if sqlmap is installed
if ! command -v sqlmap &> /dev/null; then
    log "${RED}sqlmap could not be found. Please install it before running this script.${RESET}"
    exit 1
fi

# Function to show usage
usage() {
    log "${CYAN}Usage: $0 -u URL [-p PARAM] [-D DATABASE] [-T TABLE] [-C COLUMN] [OPTIONS]${RESET}"
    log ""
    log "Options:"
    log "  -u URL        Target URL"
    log "  -p PARAM      Parameter to test for injection (optional)"
    log "  -D DATABASE   Specify database name (optional)"
    log "  -T TABLE      Specify table name (optional)"
    log "  -C COLUMN     Specify column name (optional)"
    log "  --options     Additional sqlmap options (optional)"
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
        *) log "${RED}Unknown parameter passed: $1${RESET}"; usage ;;
    esac
    shift
done

# Check if URL is provided
if [ -z "$url" ]; then
    log "${RED}Target URL is required.${RESET}"
    usage
fi

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

# Run the sqlmap command and save the output to the SQLmap output file
log "${GREEN}Running sqlmap...${RESET}"
eval $sqlmap_cmd > "$sqlmap_output_file" 2>&1

# Check for the database type in the SQLmap output
db_type=$(grep -oP 'the back-end DBMS is \K\w+' "$sqlmap_output_file")

# Display the database type if found
if [ ! -z "$db_type" ]; then
    log "${CYAN}The back-end DBMS is ${YELLOW}$db_type${RESET}"
else
    log "${RED}Could not detect the database type.${RESET}"
fi

# Check if the SQLmap output file contains vulnerabilities and display them
log "${YELLOW}Checking for vulnerabilities...${RESET}"

# Extract the vulnerabilities from the SQLmap output file
vulnerabilities=$(awk '/Parameter: /,/---/' "$sqlmap_output_file")

# Extract the found databases from the SQLmap output file
databases=$(awk '/available databases/,/^\s*$/' "$sqlmap_output_file")

# Extract dumped databases from the SQLmap output file
dumped_databases=$(awk '/Database: /, /^\s*$/' "$sqlmap_output_file")

if [ ! -z "$vulnerabilities" ]; then
    log "${CYAN}=== Vulnerabilities Found ===${RESET}"
    log "$vulnerabilities"
else
    log "${GREEN}No vulnerabilities found.${RESET}"
fi

# Output the extracted information
if [ ! -z "$databases" ]; then
    log "${CYAN}=== Extracted Databases ===${RESET}"
    log "$databases"
else
    log "${RED}No databases found.${RESET}"
fi

if [ ! -z "$tables" ]; then
    log "${CYAN}=== Extracted Tables ===${RESET}"
    log "$tables"
fi

if [[ "$options" == *dump* ]]; then
    if [ ! -z "$dumped_databases" ]; then
        log "${CYAN}=== Extracted Dumped Data ===${RESET}"
        log "$dumped_databases"
    else
        log "${RED}Failed to dump database${RESET}"
    fi
fi

# Notify the user that the output has been saved
log "${CYAN}Terminal output saved to $terminal_output_file${RESET}"

# Move the terminal output to the final output file
mv "$terminal_output_file" "$final_output_file"
