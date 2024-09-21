#!/bin/bash

# Input file
input_file="./terminal_output.log"

# Output cleaned file
output_file="./final_terminal_output.log"

# Clean up ANSI escape sequences (used for colors in Gobuster and Searchsploit)
sed -E 's/\x1B\[[0-9;]*[JKmsu]//g' "$input_file" > "$output_file"

# Optionally, remove non-printable characters
# tr -cd '\11\12\15\40-\176' < "$output_file" > tmpfile && mv tmpfile "$output_file"

echo "Cleaned report generated: $output_file"
sudo rm  $input_file;
mv $output_file $input_file
