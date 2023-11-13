#!/bin/bash

# List of keywords to be quoted
keywords=("private.api.addr" "http.api" "http.port" "authrpc.port" "torrent.port")

# Your TOML file
toml_file="/etc/eth-node-erigon-service-sepolia/config.toml"
input_string=$(grep 'http.api' "$toml_file")
value=$(echo "$input_string" | awk -F' = ' '{print $2}' | tr -d '"')
IFS=',' read -ra value_array <<< "$value"
# Initialize the formatted string

# Loop through the array and format each element
for ((i=0; i<${#value_array[@]}; i++)); do
    # Add double quotes around each element
    formatted_string+="\"${value_array[$i]}\""

    # Add a comma if it's not the last element
    if [ $i -lt $(( ${#value_array[@]} - 1 )) ]; then
        formatted_string+=", "
    fi
done

# Close the JSON array
sed -i "s/$input_string/http.api = [$formatted_string]/" "$toml_file"

# Loop through the keywords and quote them in the TOML file
for keyword in "${keywords[@]}"; do
    # Check if the keyword is not already quoted
    if ! grep -q "\"$keyword\"" "$toml_file"; then
        # Quote the keyword
        sed -i "s/$keyword/\"$keyword\"/g" "$toml_file"
    fi
done

