#Pool counting from multiple files, add 0 for missing value 
#!/bin/bash

# Check if at least one input file is provided
if [ $# -eq 0 ]; then
    echo "Error: No input files provided"
    echo "Usage: $0 SETA SETB [SETC SETD ...]"
    exit 1
fi

# Check if all input files exist
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: File $file not found"
        exit 1
    fi
done

# Create header for output file (NAME followed by each set name)
output_file="PoolOutput"
echo -n "NAME" > "$output_file"
for file in "$@"; do
    echo -n -e "\t$file" >> "$output_file"
done
echo "" >> "$output_file"

# Extract all unique names from input files
awk 'NR>1 {print $1}' "$@" | sort -u > temp_names

# Process each name and get counts from all files
while IFS= read -r name; do
    # Start output line with the name
    line="$name"
    
    # Get count from each input file
    for file in "$@"; do
        count=$(awk -v n="$name" '$1==n {print $2}' "$file")
        count=${count:-0}  # Default to 0 if not found
        line="$line\t$count"
    done
    
    # Append to output file
    echo -e "$line" >> "$output_file"
done < temp_names

# Clean up temporary file
rm temp_names

echo "Output written to $output_file"
