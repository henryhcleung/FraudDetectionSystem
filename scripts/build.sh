#!/bin/bash
set -e

echo "Building the project..."
mvn -B clean package --file pom.xml -s custom-settings.xml

echo "Running tests..."
mvn test -s custom-settings.xml

echo "Build and test completed successfully."