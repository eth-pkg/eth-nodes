#!/bin/bash
SOURCE_DIR="keys"
find "$SOURCE_DIR" -type f -name "*.json" | while read -r json_file; do
    filename=$(basename "$json_file" .json).txt
    target_dir="passwords"
    mkdir -p "$target_dir"
    echo "test test" >"$target_dir/$filename"
    echo "Processed: $json_file -> $target_dir/$filename"
done
echo "Done!"
