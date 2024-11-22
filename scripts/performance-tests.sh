#!/bin/bash
set -e

# Set variables
API_URL="http://localhost:8080"
TEST_ENDPOINT="/api/v1/fraud-detection"
REQUESTS=1000
CONCURRENCY=10

# Function to run performance tests
run_performance_tests() {
    echo "Running performance tests..."
    ab -n $REQUESTS -c $CONCURRENCY -T 'application/json' -p performance_test_payload.json ${API_URL}${TEST_ENDPOINT}
}

# Create a sample payload file
echo '{"transactionId":"123","amount":100}' > performance_test_payload.json

# Run the performance tests
run_performance_tests

# Clean up
rm performance_test_payload.json