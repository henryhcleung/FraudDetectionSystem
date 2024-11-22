#!/bin/bash
set -e

# Set variables
API_URL="http://localhost:8080"
HEALTH_ENDPOINT="/actuator/health"
TEST_ENDPOINT="/api/v1/fraud-detection"

# Function to check API health
check_health() {
    echo "Checking API health..."
    health_status=$(curl -s -o /dev/null -w "%{http_code}" ${API_URL}${HEALTH_ENDPOINT})
    if [ $health_status -eq 200 ]; then
        echo "API is healthy"
    else
        echo "API health check failed with status code: $health_status"
        exit 1
    fi
}

# Function to run a simple test
run_test() {
    echo "Running smoke test..."
    test_result=$(curl -s -X POST -H "Content-Type: application/json" -d '{"transactionId":"123","amount":100}' ${API_URL}${TEST_ENDPOINT})
    if [[ $test_result == *"isFraudulent"* ]]; then
        echo "Smoke test passed"
    else
        echo "Smoke test failed"
        exit 1
    fi
}

# Main function to run all tests
run_smoke_tests() {
    check_health
    run_test
}

# Run the smoke tests
run_smoke_tests