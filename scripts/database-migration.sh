#!/bin/bash
set -e

# Ensure the script is run from the project root
cd "$(dirname "$0")/.."

# Run Flyway migrations
echo "Running Flyway migrations..."
mvn flyway:migrate -s custom-settings.xml

echo "Database migration completed successfully."