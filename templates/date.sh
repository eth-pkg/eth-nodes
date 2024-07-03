#!/bin/bash

# Capture the current date and time in a format suitable for conversion
current_datetime=$(date +"%Y-%m-%dT%H:%M:%S%z")

# Function to format the date in the desired format for the changelog
format_changelog_date() {
    local datetime=$1
    echo $(date -d "$datetime" +"%a, %d %b %Y %H:%M:%S %z")
}

# Function to format the date in another desired format (example)
format_another_date() {
    local datetime=$1
    echo $(date -d "$datetime" +"%Y-%m-%dT%H:%M:%S%z")
}

# Example usage
CHANGELOG_BUILD_DATE=$(format_changelog_date "$current_datetime")
ANOTHER_FORMATTED_DATE=$(format_another_date "$current_datetime")

echo "CHANGELOG_BUILD_DATE=\"$CHANGELOG_BUILD_DATE\""
echo "ANOTHER_FORMATTED_DATE=\"$ANOTHER_FORMATTED_DATE\""

