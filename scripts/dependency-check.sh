#!/bin/bash

# Set the Dependency-Check version
DC_VERSION="11.1.0"

# Set the directory where Dependency-Check is installed
DC_DIR="/opt/dependency-check"

# Set the output directory for the report
OUTPUT_DIR="/workspace/reports"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run Dependency-Check
$DC_DIR/bin/dependency-check.sh --project "FraudDetectionSystem" --scan "/workspace" --format "HTML" --out "$OUTPUT_DIR"

# Check the exit code of Dependency-Check
if [ $? -ne 0 ]; then
    echo "Dependency-Check failed."
    exit 1
fi

echo "Dependency-Check completed successfully."