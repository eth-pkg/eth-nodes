#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <variant>"
    exit 1
fi

# Extract the variant name from the command line arguments
variant="$1"
config_file="/etc/eth-node-service-${variant}/config.toml"

# Check if the config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Config file '$config_file' not found."
    exit 1
fi

# Read the dir_name and jwt_secret from the TOML file
data_dir=$(awk -F' = ' '/^datadir/ { gsub(/"/, "", $2); print $2 }' "$config_file")
jwt_secret_file=$(awk -F' = ' '/^jwtsecret/ { gsub(/"/, "", $2); print $2 }' "$config_file")

# Check if the dir_name is empty
if [ -z "$dir_name" ]; then
    echo "Error: 'dir_name' not found or empty in the config file."
    exit 1
fi

# Create the directory for data_dir if it doesn't exist
mkdir -p "$data_dir"

# Display a message
echo "Directory '$data_dir' created."

# Check if the jwt_secret_file is empty or not provided
if [ -z "$jwt_secret_file" ]; then
    echo "Error: 'jwt_secret' not found or empty in the config file."
    exit 1
fi

# Create the parent directories for jwt_secret_file if they don't exist
mkdir -p "$(dirname "$jwt_secret_file")"

# Check if jwt_secret file exists
if [ ! -f "$jwt_secret_file" ]; then
    # Generate a random value for jwt_secret
    openssl rand -hex 32 | tr -d "\n" > "$jwt_secret_file"

    # Display a message
    echo "jwt_secret file created at '$jwt_secret_file'."
fi

# Assign permissions for group members
group_name = "eth-node-service-${variant}"

# Check if the group exists, and create it if not
if ! getent group "$group_name" >/dev/null 2>&1; then
    groupadd "$group_name"
    echo "Group '$group_name' created."
fi

chown -R :"$group_name" "$data_dir"
chmod g+rwx "$data_dir"

# Display a message
echo "Permissions assigned to group '$group' for directory '$data_dir'."

