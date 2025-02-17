#!/bin/bash

# Input and output files
ENV_FILE=".env"
OUTPUT_FILE="lib/env_options.dart"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE not found."
    exit 1
fi

# Start writing to the output Dart file
{
    echo "// ignore_for_file: constant_identifier_names"
    echo "sealed class EnvOptions {"

    # Read each line of the .env file
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty or whitespace-only lines
        if [[ -n "${line// }" ]]; then
            echo "  static const String $line;"
        fi
    done < "$ENV_FILE"

    echo "}"
} > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE successfully."
